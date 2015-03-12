module particulate.particle;

import std.traits;

struct Particle(T) {
    T pos;
    float size, r, g, b; // Intensity of colors in [0, 1]
}
