#ifndef CORE_MORE_H
#define CORE_MORE_H
#include <SDL.h>
#include "cpf_additions.h"

// Rotate a surface of 8, 16 or 32 bits per pixel
SDL_Surface* rotateSurface90Degrees_all(SDL_Surface* src, int numClockwiseTurns);

// Mirror a surface by the X axe of 8, 16 or 32 bits per pixel
SDL_Surface* MirrorSurfaceX( SDL_Surface *src );

// Mirror a surface by the Y axe of 8, 16 or 32 bits per pixel
SDL_Surface* MirrorSurfaceY( SDL_Surface *src );

// Copy the color palette of a 8 bits per pixel surface to another 8 bits per pixel
void CopyPalette_8( SDL_Surface * src, SDL_Surface * dst);

// Get the pixel value on a surface (must lock the surface before calling this function)
Uint32 getpixel(SDL_Surface *surface, int x, int y);

// Set a pixel on a surface (must lock the surface before calling this function)
void putpixel(SDL_Surface *surface, int x, int y, Uint32 pixel);

// Return true if the surface need to be lock before using the putpixel or get_pixel function.
int SDL_MUSTLOCK_ALT(SDL_Surface *surface);

void setSDLRWops(SDL_RWops *rwop,CustomPackageFileInfos* cpfInfos);


#endif
