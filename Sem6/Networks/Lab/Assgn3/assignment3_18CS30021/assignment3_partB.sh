#! /bin/bash

# --------------------------
# COMPUTER NETWORKS LAB ASSIGNMENT 2
# NAME : Itish Agarwal
# ROLL : 18CS30021
# Part 1
# --------------------------

# creating namespaces H1, H2, H3, R
sudo ip netns add H1
sudo ip netns add H2
sudo ip netns add H3
sudo ip netns add R

# create veth pairs
# veth1 <----> veth2
sudo ip link add veth1 type veth peer name veth2
# veth3 <----> veth6
sudo ip link add veth3 type veth peer name veth6
# veth4 <----> veth5
sudo ip link add veth4 type veth peer name veth5


# attach veths to namespaces :-
# veth1 ---> H1
sudo ip link set veth1 netns H1
# veth2 ---> R
sudo ip link set veth2 netns R
# veth3 ---> R
sudo ip link set veth3 netns R
# veth4 ---> R
sudo ip link set veth4 netns R
# veth5 ---> H3
sudo ip link set veth5 netns H3
# veth6 ---> H2
sudo ip link set veth6 netns H2


# configure namespaces :-

# veth1 in H1
sudo ip netns exec H1 ip addr add 10.0.10.21/24 dev veth1
sudo ip netns exec H1 ip link set dev veth1 up

# veth2 in R
sudo ip netns exec R ip addr add 10.0.10.1/24 dev veth2
sudo ip netns exec R ip link set dev veth2 up

# veth3 in R
sudo ip netns exec R ip addr add 10.0.20.1/24 dev veth3
sudo ip netns exec R ip link set dev veth3 up

# veth4 in R
sudo ip netns exec R ip addr add 10.0.30.1/24 dev veth4
sudo ip netns exec R ip link set dev veth4 up

# veth5 in H3
sudo ip netns exec H3 ip addr add 10.0.30.21/24 dev veth5
sudo ip netns exec H3 ip link set dev veth5 up

# veth6 in H2
sudo ip netns exec H2 ip addr add 10.0.20.21/24 dev veth6
sudo ip netns exec H2 ip link set dev veth6 up


# now setting up of the namespace network has been done and veths have
# been configured in their respective namespaces

# next step is to setup the bridge in the namespace R and enable ip forwarding 


# making bridge -> we create a bridge named 'bridge_at_r' in namespace R to connect all the three veths in R
sudo ip netns exec R brctl addbr bridge_at_r

# adding interfaces to bridge -> connecting veth2 veth3 and veth4 in namespace R
sudo ip netns exec R brctl addif bridge_at_r veth2 veth3 veth4

# setting bridge to 'up' (ie, enabling the bridge to work)
sudo ip -n R link set dev bridge_at_r up

# enable IP Forwarding 
sudo ip netns exec R sysctl -w net.ipv4.ip_forward=1

sudo ip -n H1 route add default via 10.0.10.21
sudo ip -n H2 route add default via 10.0.20.21
sudo ip -n H3 route add default via 10.0.30.21
