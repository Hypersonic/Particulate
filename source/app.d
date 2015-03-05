import std.stdio;
import particulate.system;
import particulate.particle;

void main()
{
    auto func = delegate(float t, ulong n) {
        return Particle!int(cast(int) (t * n), 0, 0, 0, 0, 0);
    };
    auto sys = ParticleSystem(0, func);
    foreach (part; sys.at(10)) {
        writeln(part);
    }
}
