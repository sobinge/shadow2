/* Boyer-Moore string search as found on the internet using Google */

#include <pthread.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

#include "bm.h"

#define MAX(a,b) ((a) < (b) ? (b) : (a))



static void
preBmBc(unsigned char *x,
	int m,
	int bmBc[])
{
    int i;
    
    for (i = 0; i < BM_ASIZE; ++i)
	bmBc[i] = m;
    
    for (i = 0; i < m - 1; ++i)
	bmBc[x[i]] = m - i - 1;
}


static void
suffixes(unsigned char *x,
	 int m,
	 int *suff)
{
    int f, g, i;


    f = 0;
    suff[m - 1] = m;
    g = m - 1;
    for (i = m - 2; i >= 0; --i)
    {
	if (i > g && suff[i + m - 1 - f] < i - g)
	    suff[i] = suff[i + m - 1 - f];
	else
	{
	    if (i < g)
		g = i;
	    f = i;
	    while (g >= 0 && x[g] == x[g + m - 1 - f])
		--g;
	    suff[i] = f - g;
	}
    }
}


static int
preBmGs(unsigned char *x, int m, int bmGs[])
{
    int i, j, *suff;


    suff = (int *) calloc(sizeof(int), m);
    if (suff == NULL)
	return -1;
    
    suffixes(x, m, suff);
    
    for (i = 0; i < m; ++i)
	bmGs[i] = m;

    j = 0;
    for (i = m - 1; i >= -1; --i)
	if (i == -1 || suff[i] == i + 1)
	    for (; j < m - 1 - i; ++j)
		if (bmGs[j] == m)
		    bmGs[j] = m - 1 - i;

    for (i = 0; i <= m - 2; ++i)
	bmGs[m - 1 - suff[i]] = m - 1 - i;

    free(suff);
    return 0;
}


int
bm_init(BM *bmp,
	unsigned char *x,
	int m,
	int icase)
{
    int i;


    memset(bmp, 0, sizeof(bmp));

    bmp->icase = icase;
    bmp->bmGs = (int *) calloc(sizeof(int), m);
    if (bmp->bmGs == NULL)
	return -1;
    
    bmp->saved_m = m;
    bmp->saved_x = (unsigned char *) malloc(m);
    if (bmp->saved_x == NULL)
	return -2;
    
    for (i = 0; i < m; i++)
	bmp->saved_x[i] = icase ? tolower(x[i]) : x[i];
    
    /* Preprocessing */
    if (preBmGs(bmp->saved_x, m, bmp->bmGs) < 0)
	return -3;
    
    preBmBc((unsigned char *) bmp->saved_x, m, bmp->bmBc);

    return 0;
}    


void
bm_destroy(BM *bmp)
{
    if (bmp->bmGs)
	free(bmp->bmGs);

    if (bmp->saved_x)
	free(bmp->saved_x);
}



/* Search for matches
**
** If mfun is defined, then call this function for each match.
** If mfun returns anything else but 0 abort the search. If the
** returned value is < 0 then return this value, else return the
** number of matches (so far).
**
** If mfun is NULL then stop at first match and return the position
*/

int
bm_search(BM *bmp,
	  unsigned char *y,
	  int n,
	  int (*mfun)(void *buf, int n, int pos))
{
    int i, j, c;
    int nm = 0;
    

    /* Searching */
    j = 0;
    while (j <= n - bmp->saved_m)
    {
	for (i = bmp->saved_m - 1;
	     i >= 0 && bmp->saved_x[i] == (bmp->icase ? tolower(y[i + j]) : y[i + j]);
	     --i)
	    ;
	
	if (i < 0)
	{
	    if (mfun)
	    {
		++nm;
		
		c = mfun(y, n, j);
		if (c)
		    return (c < 0 ? c : nm);
		
		j += bmp->bmGs[0];
	    }
	    else
		return j;
	}
	else
	{
	    unsigned char c = (bmp->icase ? tolower(y[i + j]) : y[i + j]);

	    j += MAX(bmp->bmGs[i], bmp->bmBc[c] - bmp->saved_m + 1 + i);
	}
    }

    return mfun == NULL ? -1 : nm;
}

#if 0
int
main(int argc,
     char *argv[])
{
    int pos;

    
    bm_setup(argv[1], strlen(argv[1]));

    pos = bm_search(argv[2], strlen(argv[2]));

    printf("Match at pos %d\n", pos);

    exit(0);
}
#endif
