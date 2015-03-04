module particulate.system;

import std.range;

import particulate.particle;

struct ParticleSystem {
    private immutable float t;
    private immutable Particle[] particles;
    private immutable Particle function(float t, ulong n) part_func;

    this(float t) {
        this.t = t;
        part_func = function(float t, ulong n) {
            return Particle(cast(int) (t * n));
        };
        Particle[] _parts;
        foreach (n; 0 .. 100) {
            _parts ~= part_func(t, n);
        }
        particles = cast(immutable Particle[]) _parts;
    }

    ParticleSystem at(float t) {
        return this; // TEMP: Later this will be changed
    }

    int opApply(int delegate(Particle) dg) {
        auto result = 0;
        foreach (particle; particles) {
            result = dg(particle);
            if (result)
                break;
        }
        return result;
    }
}
