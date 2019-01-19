import seaborn as sns
import matplotlib.pylab as plt
import pandas as pd

data = pd.read_csv("usage.csv", index_col=0)
ax = sns.heatmap(data, linewidth=0.25, square=True, cmap="RdPu")
ax.tick_params(axis=u'both', which=u'both',length=0)
cbar = ax.collections[0].colorbar
cbar.set_ticks([0,1,2,3,4,5,6,7,8])
plt.savefig('usage.png')

