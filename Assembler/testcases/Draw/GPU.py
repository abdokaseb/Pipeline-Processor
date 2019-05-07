import numpy as np
import matplotlib.pyplot as plt
import matplotlib.colors

f = open('exported.mem')
lines = f.readlines()[3:]
a = np.zeros((len(lines)+5,65))
i = 3
for line in lines:
    a[i] = [int(x) for x in ''.join(['0','0','0'] + line.split(':')[-1].split(' '))[:-15].replace('A','3')]
    i += 1

ca = np.array([[3,255,00,00],
               [0,0,0,0]])

u, ind = np.unique(a, return_inverse=True)
b = ind.reshape((a.shape))

colors = ca[ca[:,0].argsort()][:,1:]/255.
cmap = matplotlib.colors.ListedColormap(colors)
norm = matplotlib.colors.BoundaryNorm(np.arange(len(ca)+1)-0.5, len(ca))

plt.imshow(b, cmap=cmap, norm=norm)


plt.show()
