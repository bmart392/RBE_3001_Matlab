function T = clamp(input, low, high)

% This function limits the result to be in between the low and high parameters.
% This is especially helpful for inverse trig operations, like acos and asin.

    if (input < low)
            T = low;
        elseif (input > high)
            T = high;
        else
        T = input;
    end
end