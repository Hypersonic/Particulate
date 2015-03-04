import std.stdio;
import particulate.system;

void main()
{
    auto sys = ParticleSystem(10);
    foreach (part; sys) {
        part.x += 1;
        writeln(part);
    }
}
