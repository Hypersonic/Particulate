module particulate.system;

import std.range;

import particulate.particle;

struct ParticleSystem {
    private immutable float t;
    private immutable ulong n_parts;
    /* A function that given a t and which particle this is
     * This function may be called in any order, don't rely on state
     */
    private immutable Particle!int delegate(float t, ulong n) part_func;

    this(float t, ulong n, Particle!int delegate(float, ulong) part_func) {
        this.t = t;
        this.n_parts = n;
        this.part_func = part_func;
    }

    ParticleSystem at(float t) {
        return ParticleSystem(t, n_parts, part_func);
    }

    // Allow foreach over a system
    int opApply(int delegate(Particle!int) dg) {
        auto result = 0;
        foreach (n; 0 .. n_parts) {
            result = dg(part_func(t, n));
            if (result)
                break;
        }
        return result;
    }
}
