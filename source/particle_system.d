module particulate.system;

import std.range;

import particulate.particle;

struct ParticleSystem {
    private immutable float t;
    private immutable Particle[] particles;
    /* A function that given a t and which particle this is
     * This function may be called in any order, don't rely on state
     */
    private immutable Particle delegate(float t, ulong n) part_func;

    this(float t, Particle delegate(float, ulong) part_func) {
        this.t = t;
        this.part_func = part_func;
        Particle[] _parts;
        foreach (n; 0 .. 10) {
            _parts ~= part_func(t, n);
        }
        particles = cast(immutable Particle[]) _parts;
    }

    ParticleSystem at(float t) {
        return ParticleSystem(t, part_func);
    }

    // Allow foreach over a system
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
