# floo returns the greatest integer value less than or equal to x.
function floor(x) {
    if (int(x) == x) {
        return x;
    } else if (x > 0){
        return int(x);
    } else {
        return int(x) - 1;
    }
}

# ceil returns the least integer value greater than or equal to x.
function ceil(x) {
    if (int(x) == x) {
        return x;
    } else if (x > 0) {
        return int(x) + 1;
    } else {
        return x;
    }
}

# round returns the rounded value to x
function round(x) {
    if (x > 0) {
        return int(x + 0.5);
    } else {
        return int(x - 0.5);
    }
}
