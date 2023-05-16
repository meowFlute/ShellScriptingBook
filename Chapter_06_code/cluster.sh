#!/bin/bash

NODES="node1 node2 node3"
echo >> /etc/hosts
echo "### Cluster peers" >> /etc/hosts
echo "# Added on `date`" >> /etc/hosts
for node in $NODES
do
  getent hosts $node >> /etc/hosts
done
echo "### End of Cluster peers" >> /etc/hosts
