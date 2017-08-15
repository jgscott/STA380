####
# Marriage and the Medici clan
####

## load the igraph package
library(igraph) 

medici = as.matrix(read.table("../data/medici.txt"))

## create the graph object
marriage = graph.edgelist(medici, directed=FALSE)

## set some color atributes (V() gives back the 'vertices' = nodes)
V(marriage)$color = "orange"
V(marriage)["Medici"]$color = "lightblue"
V(marriage)$frame.color = 0
V(marriage)$label.color = "black"

## plot it
plot(marriage, edge.curved=FALSE)

## print the degree for each family
sort(degree(marriage))

## calculate and color a couple shortest paths
PtoA = get.shortest.paths(marriage, from="Peruzzi", to="Acciaiuoli")
allPtoA = all_shortest_paths(marriage, from="Peruzzi", to="Acciaiuoli")


# Somewhat confusing return value
# vpath is a list of the shortest paths 
# First element of vpath is then your vector 
# of vertices along the path.

PtoA$vpath[[1]]

GtoS = get.shortest.paths(marriage, from="Ginori", to="Strozzi")
GtoS$vpath[[1]]

# color the edges along these paths
# and set the rest to grey
E(marriage)$width = 2
E(marriage)$color = "grey"
E(marriage, path=PtoA$vpath[[1]])$color = "purple"
E(marriage, path=GtoS$vpath[[1]])$color = "darkgreen"
plot(marriage)

## print the betweenness for each family
sort(round(betweenness(marriage),1))
