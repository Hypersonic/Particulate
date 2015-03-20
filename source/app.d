import std.stdio;
import std.conv;
import std.math;
import std.algorithm;

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

    struct Guy {
        int x;
        int y;
        float vx = 0;
        float vy = 0;
    }
    struct Wall {
        int x;
        int y;
        int width;
        int height;
    }

    Guy guy = Guy(width/2, height/2);
    Wall[] walls;
    walls ~= Wall(100, 100, 20, 400);
    walls ~= Wall(100, 500, 200, 20);

    bool isIntersecting(int p1x, int p1y, int p2x, int p2y, int p3x, int p3y, int p4x, int p4y) {
        bool CCW(int p1x, int p1y, int p2x, int p2y, int p3x, int p3y) {
                return (p3y - p1y) * (p2x - p1x) > (p2y - p1y) * (p3x - p1x);
            }
        return (CCW(p1x, p1y, p3x, p3y, p4x, p4y) != CCW(p2x, p2y, p3x, p3y, p4x, p4y)) && (CCW(p1x, p1y, p2x, p2y, p3x, p3y) != CCW(p1x, p1y, p2x, p2y, p4x, p4y));
    }

    auto func = delegate(float t, ulong n) {
        import std.random;
        auto yoffset = n * abs(1 / (guy.vy+1)) * uniform(1.0,t%4+2);
        auto xoffset = n * uniform(-1.0,1.0) * yoffset / 200 - (guy.vx*5);
        foreach (wall; walls) {
            // Test for intersection between the edges of the wall and the line from the guy to the particle we're trying to create
            bool top = isIntersecting(wall.x, wall.y, wall.x + wall.width, wall.y, guy.x, guy.y, guy.x + xoffset.to!int, guy.y + yoffset.to!int); 
            bool left = isIntersecting(wall.x, wall.y, wall.x, wall.y + wall.height, guy.x, guy.y, guy.x + xoffset.to!int, guy.y + yoffset.to!int);
            bool right = isIntersecting(wall.x + wall.width, wall.y, wall.x + wall.width, wall.y + wall.height, guy.x, guy.y, guy.x + xoffset.to!int, guy.y + yoffset.to!int);
            bool bottom = isIntersecting(wall.x + wall.width, wall.y + wall.height, wall.x + wall.width, wall.y + wall.height, guy.x, guy.y, guy.x + xoffset.to!int, guy.y + yoffset.to!int);
            if (left || right) {
                xoffset = (wall.x - guy.x) - xoffset - (guy.x - wall.x);
            }
            if (top || bottom) {
                yoffset = (wall.y - guy.y) - yoffset - (guy.y - wall.y);
            }
        }
        return Particle!(int[2])(
                [guy.x + xoffset.to!int,
                guy.y + yoffset.to!int],
                (n+1).log.to!int, 1, uniform(0.0, 1.0), 0);
    };
    auto sys = ParticleSystem(0, 100, func);

    bool running = true;
    int t = 0;
    while (running) {
        sdl2.processEvents();
        t++;

        guy.x += guy.vx;
        guy.y += guy.vy;

        guy.vx *= .6;
        guy.vy *= .6;

        renderer.setColor(255, 255, 255);
        renderer.fillRect(guy.x, guy.y, 10, 20);
        foreach (wall; walls) {
            renderer.fillRect(wall.x, wall.y, wall.width, wall.height);
        }
        foreach (part; sys.at(t)) {
            renderer.setColor(
                    (part.r * 255).to!int,
                    (part.g * 255).to!int,
                    (part.b * 255).to!int);
            renderer.fillRect(part.pos[0], part.pos[1], part.size.to!int, part.size.to!int);
        }


        renderer.present();
        renderer.setColor(0, 0, 0, 0);
        renderer.clear();

        // Exit on escape
        if (sdl2.keyboard().isPressed(SDLK_w)) {
            guy.vy -= 1;
        }
        if (sdl2.keyboard().isPressed(SDLK_s)) {
            guy.vy += 1;
        }
        if (sdl2.keyboard().isPressed(SDLK_a)) {
            guy.vx -= 1;
        }
        if (sdl2.keyboard().isPressed(SDLK_d)) {
            guy.vx += 1;
        }
        if (sdl2.keyboard().isPressed(SDLK_ESCAPE)) {
            running = false;
        }
    }

}
