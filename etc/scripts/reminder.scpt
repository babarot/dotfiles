#!/usr/bin/env osascript


property MonthNames : {January, February, March, April, May, June, July, August, September, October, November, December}

on DateToString(theDate)
    set Y to ((year of theDate) - 2000) as text
    set m to Num2Txt(Month2Num(month of theDate))
    set D to Num2Txt(day of theDate)
    set h to (time of theDate) div hours
    set mi to (time of theDate) mod hours div minutes
    set s to (time of theDate) mod minutes
    if (count characters of (h as text)) is 1 then set h to "0" & (h as text)
    if (count characters of (mi as text)) is 1 then set mi to "0" & (mi as text)
    if (count characters of (s as text)) is 1 then set s to "0" & (s as text)
    return Y & "." & m & "." & D & "-" & h & "." & mi & "." & s
end DateToString

on Num2Txt(NUM)
    return text -2 thru -1 of ("0" & (NUM as text))
end Num2Txt

on Month2Num(m)
    repeat with I from 1 to 12
        if item I of MonthNames = m then return I
    end repeat
end Month2Num

set aName to DateToString(current date)

#tell application "Reminders"
#    set duedate to (current date) + (2 * days)
#    set newToDo to make new reminder with properties {name:"Test", body:"あああああっｊ", due date:}
#end tell
