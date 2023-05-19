# kruskal-gleephs

This is my third (and final?) project to randomly generate Breath of the Wild-esque glyphs.

To recap, in the Legend of Zelda: Breath of the Wild you will often run into interesting looking fictional (hiero)glyphs. Upon closer inspection, you can deduce a couple of rules:

- A glyph consists of a four by four grid of dots.
- Each dot can be connected to zero, one, or two horizontally or vertically adjoining dots.

Example of a 'valid' glyph:

```
######  ##  ##
######  ##  ##
##  ##
##  ##
##  ######  ##
##  ######  ##
            ##
            ##
##########  ##
##########  ##
        ##  ##
        ##  ##
##  ######  ##
##  ######  ##
```

As you can see, valid glyphs will consist of one or more 'snakes' and zero or more unconnected dots.

For a while now I have been trying to figure out algorithms to generate these glyphs, either randomly or deterministically. In the course of another project, I ran into [Kruskal's algorithm](https://github.com/andreasduerloo/Mazes#randomized-kruskals-algorithm) in the context of maze generation. I realized that with a minor tweak, that algorithm is perfect for generating glyphs.

- Consider a four by four grid of nodes, and consider all possible connections between those nodes.
- With every 'tick', take a random connection.
  - If neither of the adjoining nodes have more than one connection, activate this connection
  - If either node already has two connections, move on without activating this connection
- Discard that connection from the pool of connections, and get the next random one.