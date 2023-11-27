% FUNCTION: Gaussian Function

function gaussian = gauss_func(input_space, a, b, c)    
    %{
    Create Gaussian Function
    (works in any dimension)
    a = height of curve's peak
    b = position of the center of the peak  [x or (x,y), or (x,y,z), ...]
    c = standard deviation (width of "bell")
    %}

    gaussian = a * exp( - ((input_space - b).^2) / (2 * (c^2)) );
end