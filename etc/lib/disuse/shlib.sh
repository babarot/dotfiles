#!/bin/bash
#
# @(#) "The shellscript library" ether.sh ver.0.02 beta (c)SUNONE
#
#
# Copyright (c) 2007-2008, SUNONE
#
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
#  * Redistributions of source code must retain the above copyright notice, 
#    this list of conditions and the following disclaimer.
#
#  * Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#


#==========================================================================
# 定数設定
#==========================================================================

# 判定用 boolean 値設定
readonly TRUE=0
readonly FALSE=1

# 終了ステータス値設定( FALSE と区別できるように失敗は2とする)
readonly SUCCESS=0
readonly FAILURE=2

# フラグ値設定(フラグにはこの値を使用する)
readonly ON='ON'
readonly OFF='OFF'

# 正規表現内でのタブ検索は'\t'を使うより実際の文字列を使用した方が確実
readonly _TAB_=`printf "\t"`

# 半角スペース
readonly _SPACE_=' '

# スペースとタブ
readonly _BLANK_="${_SPACE_}${_TAB_}"

# IFSをバックアップ
readonly IFS_BAK="$IFS"


#**************************************************************************
# 標準エラーメッセージを抑止してコマンド実行(標準エラー出力を捨てる)。
# @param コマンドライン
#**************************************************************************
function @()
{
  eval "$@" 2>/dev/null
}


#**************************************************************************
# 標準エラーおよび標準出力を抑止してコマンド実行(出力を捨てる)。
# @param コマンドライン
#**************************************************************************
function _@()
{
  eval "$@" >/dev/null 2>&1
}


#**************************************************************************
# エラーメッセージを表示する(標準エラー出力へメッセージを出力する)。
# @param エラーメッセージ
#**************************************************************************
function err()
{
  echo -e "$*" 1>&2
}


#**************************************************************************
# 変数を1インクリメントする。
# @param インクメント対象の変数名
#**************************************************************************
function ++()
{
  [ $# -ne 1 ] && return $FAILURE
  eval $1='`expr $'$1' + 1`'
}


#**************************************************************************
# 変数を1デクリメントする。
# @param デクメント対象の変数名
#**************************************************************************
function --()
{
  [ $# -ne 1 ] && return $FAILURE
  eval $1='`expr $'$1' - 1`'
}


#**************************************************************************
# 変数に値を加算する。
# @param 対象の変数名
# @param 加算する値
# @return パラメータエラーは2,それ以外は0を返す。
#**************************************************************************
function +=()
{
  if [ $# -ne 2 -o `IsNumeric "$2"` != $TRUE ]; then
    return $FAILURE
  fi

  local _plus_value=`GetVarByName "$1"`
  _plus_value=$(( $_plus_value + $2 ))

  SetVarByName "$1" $_plus_value

  return $SUCCESS
}


#**************************************************************************
# 変数に値を減算する。
# @param 対象の変数名
# @param 減算する値
# @return パラメータエラーは2,それ以外は0を返す。
#**************************************************************************
function -=()
{
  if [ $# -ne 2 -o `IsNumeric "$2"` != $TRUE ]; then
    return $FAILURE
  fi

  local _minus_value=`GetVarByName "$1"`
  _minus_value=$(( $_minus_value - $2 ))

  SetVarByName "$1" $_minus_value

  return $SUCCESS
}


#**************************************************************************
# 引数に指定された文字列,引数なしの場合は標準入力からの文字列をデバッグ
# ログに出力する。デバッグログが存在しなかった場合は何もしない。
# 引数なしで標準入力から文字列を受け取った場合,その文字列をそのまま標準
# 出力へ出力する。
# @param デバッグログへ出力する文字列
# @return デバッグログファイルが存在した場合は0,それ以外は2を返す
#**************************************************************************
function DEBUG_LOG()
{
  [ ! -f "$_DEBUG_LOGFILE_" -a $# -ne 0 ] && return $FAILURE
  if [ ! -f "$_DEBUG_LOGFILE_" -a $# -eq 0 ]; then
    cat <&0
    return $FAILURE
  fi

  if [ $# -eq 0 ]; then
    {
      echo "--- `date '+%Y/%m/%d %H:%M:%S'` --------------------------------"
      cat <&0
      printf "\n\n"
    # ロギング用に付加したものは削除しておく
    } | tee -a $_DEBUG_LOGFILE_ | sed -e '1d' | head -n -2
  else
    {
      echo "--- `date '+%Y/%m/%d %H:%M:%S'` --------------------------------"
      printf "$*\n\n"
    } >>$_DEBUG_LOGFILE_
  fi

  return $SUCCESS
}
alias _DEBUG_LOG='DEBUG_LOG "$LINENO: "'
alias dbgclear="[ -f \"${_DEBUG_LOGFILE_}\" ] && : >$_DEBUG_LOGFILE_"
alias dbglog="[ -f \"${_DEBUG_LOGFILE_}\" ] && tail -f $_DEBUG_LOGFILE_"


#**************************************************************************
# 標準入力から渡された文字列中の指定したフィールドにある文字列を出力する。
# @param フィールド番号
#**************************************************************************
function Field()
{
  local _FIELD="$1"
  [ `IsNumeric "$1"` = $FALSE ] && _FIELD=1

  if [ $# -eq 1 ]; then
    cat <&0
  elif [ $# -eq 2 ]; then
    [ ! -f "$2" -o ! -r "$2" ] && return $FAILURE
    cat "$2"
  fi | awk -v FIELD="$_FIELD" '{ print $FIELD }'
}


#**************************************************************************
# 行頭から連続するタブ・半角スペースを除去する。
# @param ファイル名
#**************************************************************************
function TrimLeft()
{
  if [ $# -eq 0 ]; then
    cat <&0
  else
    [ ! -f "$1" -o ! -r "$1" ] && return $FAILURE
    cat "$1"
  fi | sed -e "s/^[$_BLANK_][$_BLANK_]*//"
}


#**************************************************************************
# 行末から連続するタブ・半角スペースを除去する。
# @param ファイル名
#**************************************************************************
function TrimRight()
{
  if [ $# -eq 0 ]; then
    cat <&0
  else
    [ ! -f "$1" -o ! -r "$1" ] && return $FAILURE
    cat "$1"
  fi | sed -e "s/[$_BLANK_][$_BLANK_]*$//"
}


#**************************************************************************
# 連続するタブ・半角スペースを1つの半角スペースに縮める。
# @param ファイル名
#**************************************************************************
function ReduceSpace()
{
  if [ $# -eq 0 ]; then
    cat <&0
  else
    [ ! -f "$1" -o ! -r "$1" ] && return $FAILURE
    cat "$1"
  fi | sed -e "s/[$_BLANK_][$_BLANK_]*/ /g"
}


#**************************************************************************
# 指定した文字列(正規表現)が存在する行の行番号を(改行区切りで)出力する。
# @param $1 検索する文字列(正規表現)
# @param $2 ファイル名
#**************************************************************************
function GetLineNo()
{
  if [ $# -eq 1 ]; then
    cat <&0
  elif [ $# -eq 2 ]; then
    cat "$2"
  fi 2>/dev/null | grep -nE "$1" | sed -e 's/^\([0-9][0-9]*\):.*$/\1/'
}


#**************************************************************************
# 文字列が数字のみで構成されるか否かを判定し,標準出力へ出力する。
# @param $1 文字列
# @return 数字だった場合は0,それ以外なら1を返す
#**************************************************************************
function IsNumeric()
{
  if [ $# -eq 0 ]; then
    cat <&0
  else
    echo "$1"
  fi | grep -E '^[0-9]+$' >/dev/null 2>&1
  if [ $? -eq $SUCCESS ]; then
    echo $TRUE
    return $TRUE
  else
    echo $FALSE
    return $FALSE
  fi
}


#**************************************************************************
# 文字列が数字のみで構成されるか否かを判定する(出力はなし)。
# @param $1 文字列
# @return 数字だった場合は0,それ以外なら1を返す
#**************************************************************************
function _IsNumeric()
{
  if [ $# -eq 0 ]; then
    cat <&0
  else
    echo "$1"
  fi | grep -E '^[0-9]+$' >/dev/null 2>&1
  if [ $? -eq $SUCCESS ]; then
    return $TRUE
  else
    return $FALSE
  fi
}


#**************************************************************************
# 文字列長が0否かを判定し,標準出力へ出力する。
# @param $1 文字列
# @return 文字列長が0だった場合は0,それ以外なら1を返す
#**************************************************************************
function IsNull()
{
  if [ $# -eq 0 ]; then
    cat <&0
  else
    echo "$1"
  fi | grep -E '^$' >/dev/null 2>&1
  if [ $? -eq $SUCCESS ]; then
    echo $TRUE
    return $TRUE
  else
    echo $FALSE
    return $FALSE
  fi
}


#**************************************************************************
# 文字列長が0否かを判定する(出力はなし)。
# @param $1 文字列
# @return 文字列長が0だった場合は0,それ以外なら1を返す
#**************************************************************************
function _IsNull()
{
  if [ $# -eq 0 ]; then
    cat <&0
  else
    echo "$1"
  fi | grep -E '^$' >/dev/null 2>&1
  if [ $? -eq $SUCCESS ]; then
    return $TRUE
  else
    return $FALSE
  fi
}


#**************************************************************************
# 文字列長が0もしくは空白のみで構成されるか否かを判定し,標準出力へ出力する。
# @param $1 文字列
# @return 文字列長が0もしくは空白だった場合は0,それ以外なら1を返す
#**************************************************************************
function IsEmpty()
{
  if [ $# -eq 0 ]; then
    cat <&0
  else
    echo "$1"
  fi | grep -E "^[$_BLANK_]*$" >/dev/null 2>&1
  if [ $? -eq $SUCCESS ]; then
    echo $TRUE
    return $TRUE
  else
    echo $FALSE
    return $FALSE
  fi
}


#**************************************************************************
# 文字列長が0もしくは空白のみで構成されるか否かを判定する(出力はなし)。
# @param $1 文字列
# @return 文字列長が0もしくは空白だった場合は0,それ以外なら1を返す
#**************************************************************************
function _IsEmpty()
{
  if [ $# -eq 0 ]; then
    cat <&0
  else
    echo "$1"
  fi | grep -E "^[$_BLANK_]*$" >/dev/null 2>&1
  if [ $? -eq $SUCCESS ]; then
    return $TRUE
  else
    return $FALSE
  fi
}


#**************************************************************************
# アルファベットの小文字を大文字に変換する。
# @param $1 ファイル名
# @return パラメータエラーは2,それ以外は0を返す。
#**************************************************************************
function UpperCase()
{
  if [ $# -eq 0 ]; then
    cat <&0
  elif [ $# -eq 1 ]; then
    if [ -f "$1" -a -r "$1" ]; then
      cat "$1"
    else
      return $FAILURE
    fi
  else
    return $FAILURE
  fi | tr '[a-z]' '[A-Z]'

  return $SUCCESS
}


#**************************************************************************
# アルファベットの大文字を小文字に変換する。
# @param $1 ファイル名
# @return パラメータエラーは2,それ以外は0を返す。
#**************************************************************************
function LowerCase()
{
  if [ $# -eq 0 ]; then
    cat <&0
  elif [ $# -eq 1 ]; then
    if [ -f "$1" -a -r "$1" ]; then
      cat "$1"
    else
      return $FAILURE
    fi
  else
    return $FAILURE
  fi | tr '[A-Z]' '[a-z]'

  return $SUCCESS
}


#**************************************************************************
# コマンドを指定した回数だけ繰り返して実行する。
# @param $1 実行回数
# @param $2 実行コマンド
# @return パラメータエラーは2,それ以外は0を返す。
#**************************************************************************
function Repeat()
{
  [ $# -ne 2 ] && return $FAILURE
  [ `IsNumeric $1` != $TRUE ] && return $FAILURE

  unset _REPEAT_STATUS

  for _i in `seq 1 $1`
  do
    eval $2
    _REPEAT_STATUS[$_i]=$?
  done

  return $SUCCESS
}


#**************************************************************************
# 文字列を指定した回数だけ繰り返して表示する。
# @param $1 表示回数
# @param $2 表示文字列
# @return パラメータエラーは2,それ以外は0を返す。
#**************************************************************************
function LoopEcho()
{
  [ `IsNumeric "$1"` != $TRUE ] && return $FAILURE

  for _i in `seq 1 $1`
  do
    echo "$2"
  done

  return $SUCCESS
}


#**************************************************************************
# 指定された変数名の変数に値を設定する。
# @param $1 変数名
# @param $2 設定値
#**************************************************************************
function SetVarByName()
{
  eval $1='$2'
}


#**************************************************************************
# 指定された変数の値を出力する。
# @param $1 変数名
#**************************************************************************
function GetVarByName()
{
  eval echo '$'$1 2>/dev/null
}


#**************************************************************************
# 配列の要素数を出力する。
# @param $1 配列名
#**************************************************************************
function ArraySize()
{
  [ $# -ne 1 ] && return $FAILURE

  local _size_array=""
  eval _size_array='("${'$1'[@]}")'

  echo ${#_size_array[*]}

  return $SUCCESS
}


#**************************************************************************
# 配列の末尾に要素を追加する。
# @param $1 配列名
# @param $2 追加する要素
#**************************************************************************
function ArrayPush()
{
  [ $# -ne 2 ] && return $FAILURE
  eval $1='("${'$1'[@]}" "$2")'

  return $SUCCESS
}


#**************************************************************************
# 配列の先頭から値を取り出す(取り出し後、各要素は前に1つずれる)。
# @param $1 配列名
#**************************************************************************
function ArrayPop()
{
  [ $# -ne 1 ] && return $FAILURE

  local _pop_array=""
  eval '_pop_array=("${'$1'[@]}")'

  [ `ArraySize "$1"` -eq 0 ] && return $FAILURE

  echo "${_pop_array[0]}"
  unset _pop_array[0]

  eval $1='("${_pop_array[@]}")'

  return $SUCCESS
}


#**************************************************************************
# 指定した文字列の各行を要素とする配列を作成する。
# @param $1 配列名
# @param $2 要素となる文字列
#**************************************************************************
function ArraySetLine()
{
  [ $# -ne 2 ] && return $FAILURE

  local _array_set_line=""

  IFS=$'\n'
  _array_set_line=($2)
  IFS="$IFS_BAK"

  eval $1='("${_array_set_line[@]}")'

  return $SUCCESS
}


#**************************************************************************
# 配列の要素をソートする。
# @param $1 配列名
#**************************************************************************
function ArraySort()
{
  [ $# -ne 1 ] && return $FAILURE

  local _sort_array=""
  eval _sort_array='("${'$1'[@]}")'

  IFS=$'\n'
  _sort_array=(`echo "${_sort_array[*]}" | sort $_ARRAY_SORT_OPT`)
  IFS="$IFS_BAK"

  eval $1='("${_sort_array[@]}")'

  return $SUCCESS
}


#**************************************************************************
# 配列の重複要素を削除する(事前にソートされている必要がある)。
# @param $1 配列名
#**************************************************************************
function ArrayUniq()
{
  [ $# -ne 1 ] && return $FAILURE

  local _uniq_array=""
  eval _uniq_array='("${'$1'[@]}")'

  IFS=$'\n'
  _uniq_array=(`echo "${_uniq_array[*]}" | uniq $_ARRAY_UNIQ_OPT`)
  IFS=$IFS_BAK

  eval $1='("${_uniq_array[@]}")'

  return $SUCCESS
}


#**************************************************************************
# 配列内から指定した文字列を検索する。。
# @param $1 文字列
# @param $2 配列名
#**************************************************************************
function ArraySearch()
{
  [ $# -ne 2 ] && return $FAILURE

  local _search_array=""
  eval _search_array='("${'$2'[@]}")'

  { ArrayJoin '\n' _search_array; } | grep -w "${1}" >/dev/null 2>&1 || return $FAILURE

  return $SUCCESS
}


#**************************************************************************
# 配列の全要素を指定した文字列を区切りとして結合して標準出力へ出力する。
# @param $1 文字列
# @param $2 配列名
#**************************************************************************
function ArrayJoin()
{
  [ $# -ne 2 ] && return $FAILURE

  local _join_array=""
  eval _join_array='("${'$2'[@]}")'

  local _size=`ArraySize _join_array`

  for _item in "${_join_array[@]}"
  do
    echo -n "${_item}"
    [ $_size -gt 1 ] && echo -ne "$1"
    _size=`expr $_size - 1`
  done

  echo -e ""

  return $SUCCESS
}


#**************************************************************************
# ファイルから1行読み込み,変数に設定する。
# @param $1 変数名
# @param $2 ファイル名
# @return 設定成功時は0,パラメータエラーおよび読み込み行オーバーは2を返す。
#**************************************************************************
function GetLine()
{
  [ $# -ne 2 -o ! -f "$2" -o ! -r "$2" ] && return $FAILURE

  local _GL_CKSUM=`cksum "$2" | Field 1`

  local _cnt=`GetVarByName "_GL_CNT_${_GL_CKSUM}"`
  [ `IsEmpty "$_cnt"` = $TRUE ] && _cnt=1

  [ $_cnt -gt `wc -l "$2" | Field 1` ] && return $FAILURE

  eval $1='`sed -n "${_cnt}p" "$2"`'

  _cnt=`expr $_cnt + 1`
  SetVarByName "_GL_CNT_${_GL_CKSUM}" $_cnt

  return $SUCCESS
}


#**************************************************************************
# 配列の全要素をツリー形式で表示する。
# @param $1 配列名
# @return 表示成功時は0,配列の要素なしおよびパラメータエラーは2を返す。
#**************************************************************************
function print_r()
{
  [ $# -ne 1 ] && return $FAILURE

  local _print_r_array=""
  eval _print_r_array='("${'$1'[@]}")'

  local _CKSTR="IS_USED_VARIABLE"
  local _SIZE=`ArraySize _print_r_array`

  [ ! "$_SIZE" -gt 0 ] && return $FAILURE

  local _cnt=0
  local _i=0

  echo "${1}[@]"
  echo " |"

  local _item=""
  local _ckitem=""
  while [ $_cnt -lt $_SIZE ]
  do
    _item=`eval echo '"${'$1'[${_i}]}"'`
    _ckitem=`eval echo '"${'$1'[${_i}]-$_CKSTR}"'`
    if [ "$_item" = "$_CKSTR" ]; then
      eval echo '" |-[${_i}] = [${'$1'[$_i]}"]'
      _cnt=`expr $_cnt + 1`
    else
      if [ "$_ckitem" != "$_CKSTR" ]; then
        eval echo '" |-[${_i}] = [${'$1'[$_i]}"]'
        _cnt=`expr $_cnt + 1`
      fi
    fi

    _i=`expr $_i + 1`
  done

  return $SUCCESS
}

