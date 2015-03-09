import std.stdio;
import std.conv;
import std.math;

import particulate.system;
import particulate.particle;

import gfm.sdl2;

void main()
{
    auto width = 1000;
    auto height = 1000;
    auto sdl2 = new SDL2(null); 
    auto window = new SDL2Window(sdl2, 
            SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED,
            width, height,
            SDL_WINDOW_SHOWN);
    auto renderer = new SDL2Renderer(window);

    auto func = delegate(float t, ulong n) {
        return Particle!int(
                (100 * (t/100.0).sin + n * 100).to!int,
                (100 * (t/100.0).cos).to!int,
                10, 1, .5, 1);
    };
    auto sys = ParticleSystem(0, 100, func);

    bool running = true;
    int t = 0;
    while (running) {
        sdl2.processEvents();
        t++;

        foreach (part; sys.at(t)) {
            renderer.setColor(
                    (part.r * 255).to!int,
                    (part.g * 255).to!int,
                    (part.b * 255).to!int);
            renderer.fillRect(part.x + width/2, part.y + height / 2, part.size, part.size);
        }


        renderer.present();
        renderer.setColor(0, 0, 0, 0);
        renderer.clear();

        // Exit on escape
        if (sdl2.keyboard().isPressed(SDLK_ESCAPE)) {
            running = false;
        }
    }

}
