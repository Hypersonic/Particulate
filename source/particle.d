module particulate.particle;

import std.traits;

struct Particle(T) if (isNumeric!T) {
    T x, y, size;
    float r, g, b; // Intensity of colors in [0, 1]
}
