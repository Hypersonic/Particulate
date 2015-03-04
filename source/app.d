import std.stdio;
import particulate.system;
import particulate.particle;

void main()
{
    auto func = delegate(float t, ulong n) {
        return Particle(cast(int) (t * n));
    };
    auto sys = ParticleSystem(0, func);
    foreach (part; sys.at(10)) {
        part.x += 1;
        writeln(part);
    }
}
