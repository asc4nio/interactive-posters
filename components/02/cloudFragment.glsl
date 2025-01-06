precision highp float;
precision highp sampler3D;

uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;

in vec3 vOrigin;
in vec3 vDirection;

out vec4 color;

uniform vec3 base;
uniform sampler3D map;
uniform float threshold;
uniform float range;
uniform float opacity;
uniform float steps;
uniform float frame;

// Hash function from https://gist.github.com/badboy/6266136#gistcomment-1916895
// This is a simple hash function that takes a uint and returns a new uint
// It's used to generate a pseudo-random number
uint wang_hash(uint seed)
{
        // xor the seed with 61 and shift it right by 16 bits
        seed = (seed ^ 61u) ^ (seed >> 16u);
        // multiply the seed by 9
        seed *= 9u;
        // xor the seed with itself shifted right by 4 bits
        seed = seed ^ (seed >> 4u);
        // multiply the seed by a large prime number
        seed *= 0x27d4eb2du;
        // xor the seed with itself shifted right by 15 bits
        seed = seed ^ (seed >> 15u);
        // return the resulting uint
        return seed;
}

// Function to generate a pseudo-random float between 0 and 1
// It takes the seed as an argument and modifies it in place
float randomFloat(inout uint seed)
{
        // call the hash function to generate a new seed
        return float(wang_hash(seed)) / 4294967296.;
}

// Function to calculate the intersection of a ray with a cube
// It takes the ray origin and direction as arguments and returns a vec2
// containing the minimum and maximum t values of the intersection
vec2 hitBox( vec3 orig, vec3 dir ) {
    // define the minimum and maximum points of the cube
    const vec3 box_min = vec3( - 0.5 );
    const vec3 box_max = vec3( 0.5 );
    // calculate the inverse of the ray direction
    vec3 inv_dir = 1.0 / dir;
    // calculate the t values for the intersection with the cube
    vec3 tmin_tmp = ( box_min - orig ) * inv_dir;
    vec3 tmax_tmp = ( box_max - orig ) * inv_dir;
    // find the minimum and maximum t values
    vec3 tmin = min( tmin_tmp, tmax_tmp );
    vec3 tmax = max( tmin_tmp, tmax_tmp );
    // calculate the minimum and maximum t values
    float t0 = max( tmin.x, max( tmin.y, tmin.z ) );
    float t1 = min( tmax.x, min( tmax.y, tmax.z ) );
    // return the minimum and maximum t values as a vec2
    return vec2( t0, t1 );
}

// Function to sample the 3D texture at a given position
// It takes the position as an argument and returns a float
float sample1( vec3 p ) {
    // sample the 3D texture at the given position
    return texture( map, p ).r;
}

// Function to calculate a simple shading effect based on the gradient of the
// 3D texture
// It takes the position as an argument and returns a float
float shading( vec3 coord ) {
    // define the step size for the gradient calculation
    float step = 0.01;
    // sample the 3D texture at the given position and at a position
    // slightly in the negative and positive x direction
    // and calculate the gradient of the texture
    return sample1( coord + vec3( - step ) ) - sample1( coord + vec3( step ) );
}

// Function to convert a linear color to sRGB
// It takes a vec4 as an argument and returns a vec4
vec4 linearToSRGB( in vec4 value ) {
    // if the color is below a certain threshold, use the linear color
    // otherwise, use the sRGB color
    return vec4( mix( pow( value.rgb, vec3( 0.41666 ) ) * 1.055 - vec3( 0.055 ), value.rgb * 12.92, vec3( lessThanEqual( value.rgb, vec3( 0.0031308 ) ) ) ), value.a );
}

void main(){
    // Get the ray direction from the origin to the fragment position
    vec3 rayDir = normalize( vDirection );

    // Find the intersection of the ray with the cube
    // The cube is centered at (0,0,0) and is of size (1,1,1)
    vec2 bounds = hitBox( vOrigin, rayDir );

    // If the ray doesn't intersect the cube, discard this fragment
    if ( bounds.x > bounds.y ) discard;

    // Make sure the ray starts at the correct position
    bounds.x = max( bounds.x, 0.0 );

    // Start the ray at the correct position
    vec3 p = vOrigin + bounds.x * rayDir;

    // Calculate the increment vector of the ray
    // This is the vector that will be added to the ray position
    // at each iteration of the loop
    vec3 inc = 1.0 / abs( rayDir );

    // Calculate the delta value for the loop
    // This is the amount that the ray position will be incremented
    // at each iteration of the loop
    float delta = min( inc.x, min( inc.y, inc.z ) );

    // Divide the delta by the number of steps to get the step size
    delta /= steps;

    // Jitter the ray position to reduce aliasing
    // This is done by adding a random number between -1 and 1
    // to the ray position
    // The seed for the random number is based on the fragment position
    // and the frame number
    uint seed = uint( gl_FragCoord.x ) * uint( 1973 ) + uint( gl_FragCoord.y ) * uint( 9277 ) + uint( frame ) * uint( 26699 );
    vec3 size = vec3( textureSize( map, 0 ) );
    float randNum = randomFloat( seed ) * 2.0 - 1.0;
    p += rayDir * randNum * ( 1.0 / size );

    // Initialize the accumulated color to black with zero alpha
    vec4 ac = vec4( base, 0.0 );

    // Loop through the cube and accumulate the color
    for ( float t = bounds.x; t < bounds.y; t += delta ) {

        // Sample the noise texture at the current position
        float d = sample1( p + 0.5 );

        // Smoothstep the sample value to get a more natural-looking
        // gradient
        d = smoothstep( threshold - range, threshold + range, d ) * opacity;

        // Calculate the color of the current position based on the
        // sample value and the position
        float col = shading( p + 0.5 ) * 3.0 + ( ( p.x + p.y ) * 0.25 ) + 0.2;

        // Accumulate the color into the accumulated color
        ac.rgb += ( 1.0 - ac.a ) * d * col;

        // Accumulate the alpha of the current sample into the
        // accumulated alpha
        ac.a += ( 1.0 - ac.a ) * d;

        // If the accumulated alpha is greater than or equal to 0.95,
        // break out of the loop, since we don't need to continue
        // accumulating any more.
        if ( ac.a >= 0.95 ) break;

        // Increment the ray position by the step size
        p += rayDir * delta;

    }

    // Convert the accumulated color from linear to sRGB
    color = linearToSRGB( ac );

    // If the accumulated alpha is zero, discard this fragment
    if ( color.a == 0.0 ) discard;

}