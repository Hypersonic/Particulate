module particulate.system;

import std.range;

import particulate.particle;

struct ParticleSystem(ParticleType = Particle!(int[2])) {
    private immutable float t;
    private immutable ulong n_parts;
    /* A function that given a t and which particle this is
     * This function may be called in any order, don't rely on state
     */
    private immutable ParticleType delegate(float t, ulong n) part_func;

    @safe this(float t, ulong n, ParticleType delegate(float, ulong) part_func) {
        this.t = t;
        this.n_parts = n;
        this.part_func = part_func;
    }

    @safe ParticleSystem at(float t) {
        return ParticleSystem(t, n_parts, part_func);
    }

    // Allow foreach over a system
    int opApply(int delegate(ParticleType) dg) {
        auto result = 0;
        foreach (n; 0 .. n_parts) {
            result = dg(part_func(t, n));
            if (result)
                break;
        }
        return result;
    }
}
