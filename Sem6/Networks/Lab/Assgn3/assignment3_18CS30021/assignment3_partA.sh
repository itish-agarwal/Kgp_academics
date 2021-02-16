#! /bin/bash

# --------------------------
# COMPUTER NETWORKS LAB ASSIGNMENT 2
# NAME : Itish Agarwal
# ROLL : 18CS30021
# Part 1
# --------------------------

# creating namespaces NS0 and NS1
sudo ip netns add NS0
sudo ip netns add NS1

# create a veth pair: Veth0 <----> Veth1
sudo ip link add Veth0 type veth peer name Veth1

# attach Veth0 to NS0
sudo ip link set Veth0 netns NS0

# attach Veth1 to NS1
sudo ip link set Veth1 netns NS1

# configure Veth0 interface in NS0 namespace
# SYNTAX : ip netns exec <namespace_name> <command>
sudo ip netns exec NS0 ip addr add 10.1.1.0/24 dev Veth0
# setting up Veth0
sudo ip netns exec NS0 ip link set dev Veth0 up

# configure Veth1 interface in NS1 namespace
# SYNTAX : ip netns exec <namespace_name> <command>
sudo ip netns exec NS1 ip addr add 10.1.2.0/24 dev Veth1
# setting up Veth1
sudo ip netns exec NS1 ip link set dev Veth1 up

# routing the veth
sudo ip netns exec NS0 ip route add default via 10.1.1.0 dev Veth0
sudo ip netns exec NS1 ip route add default via 10.1.2.0 dev Veth1

# we can use these commands to ping 
# to ping NS1 from NS0 : sudo ip netns exec NS0 ping 10.1.2.0
# to ping NS0 from NS1 : sudo ip netns exec NS1 ping 10.1.1.0
