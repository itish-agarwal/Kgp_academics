#! /bin/bash

CYAN='\033[1;36m'
ORANGE='\033[1;33m'
GREEN=`tput setaf 118`
NC='\033[0m' # No Color

#create the namespaces
sudo ip netns add N1
sudo ip netns add N2
sudo ip netns add N3
sudo ip netns add N4
sudo ip netns add N5
sudo ip netns add N6


#create a veth pair : v1-v2
sudo ip link add V1 type veth peer name V2

#create a veth pair : v3-v4
sudo ip link add V3 type veth peer name V4
 
#create a veth pair : v5-v6
sudo ip link add V5 type veth peer name V6

#create a veth pair : v7-v8
sudo ip link add V7 type veth peer name V8

#create a veth pair : v9-v10
sudo ip link add V9 type veth peer name V10
 
#create a veth pair : v11-v12
sudo ip link add V11 type veth peer name V12



# attach V1 to N1
sudo ip link set V1 netns N1
# attach V2 to N2
sudo ip link set V2 netns N2
# attach V3 to N2
sudo ip link set V3 netns N2
# attach V4 to N3
sudo ip link set V4 netns N3
# attach V5 to N3
sudo ip link set V5 netns N3
# attach V6 to N4
sudo ip link set V6 netns N4
# attach V7 to N4
sudo ip link set V7 netns N4
# attach V8 to N5
sudo ip link set V8 netns N5
# attach V9 to N5
sudo ip link set V9 netns N5
# attach V10 to N6
sudo ip link set V10 netns N6
# attach V11 to N6
sudo ip link set V11 netns N6
# attach V12 to N1
sudo ip link set V12 netns N1



#assign ip addresses to veths
sudo ip netns exec N1 ip addr add 10.0.10.21/24 dev V1
sudo ip netns exec N1 ip link set dev V1 up

sudo ip netns exec N2 ip addr add 10.0.10.22/24 dev V2
sudo ip netns exec N2 ip link set dev V2 up

sudo ip netns exec N2 ip addr add 10.0.20.21/24 dev V3
sudo ip netns exec N2 ip link set dev V3 up

sudo ip netns exec N3 ip addr add 10.0.20.22/24 dev V4
sudo ip netns exec N3 ip link set dev V4 up

sudo ip netns exec N3 ip addr add 10.0.30.21/24 dev V5
sudo ip netns exec N3 ip link set dev V5 up

sudo ip netns exec N4 ip addr add 10.0.30.22/24 dev V6
sudo ip netns exec N4 ip link set dev V6 up

sudo ip netns exec N4 ip addr add 10.0.40.21/24 dev V7
sudo ip netns exec N4 ip link set dev V7 up

sudo ip netns exec N5 ip addr add 10.0.40.22/24 dev V8
sudo ip netns exec N5 ip link set dev V8 up

sudo ip netns exec N5 ip addr add 10.0.50.21/24 dev V9
sudo ip netns exec N5 ip link set dev V9 up

sudo ip netns exec N6 ip addr add 10.0.50.22/24 dev V10
sudo ip netns exec N6 ip link set dev V10 up

sudo ip netns exec N6 ip addr add 10.0.60.21/24 dev V11
sudo ip netns exec N6 ip link set dev V11 up

sudo ip netns exec N1 ip addr add 10.0.60.22/24 dev V12
sudo ip netns exec N1 ip link set dev V12 up



#******************************************************************

#enable loopback interface at each namespace (so that a namespace can ping its own interfaces)
sudo ip -n N1 link set lo up
sudo ip -n N2 link set lo up
sudo ip -n N3 link set lo up
sudo ip -n N4 link set lo up
sudo ip -n N5 link set lo up
sudo ip -n N6 link set lo up

#enable ip forwarding at N1, N2, N3, N4, N5, N6
sudo ip netns exec N1 sysctl -w net.ipv4.ip_forward=1
sudo ip netns exec N2 sysctl -w net.ipv4.ip_forward=1
sudo ip netns exec N3 sysctl -w net.ipv4.ip_forward=1
sudo ip netns exec N4 sysctl -w net.ipv4.ip_forward=1
sudo ip netns exec N5 sysctl -w net.ipv4.ip_forward=1
sudo ip netns exec N6 sysctl -w net.ipv4.ip_forward=1

#*******************************************************************


#handle routes for N1
sudo ip netns exec N1 ip route add 10.0.20.0/24 via 10.0.10.22 dev V1
sudo ip netns exec N1 ip route add 10.0.30.0/24 via 10.0.10.22 dev V1
sudo ip netns exec N1 ip route add 10.0.40.0/24 via 10.0.10.22 dev V1
sudo ip netns exec N1 ip route add 10.0.50.0/24 via 10.0.10.22 dev V1

#handle routes for N2
sudo ip netns exec N2 ip route add 10.0.30.0/24 via 10.0.20.22 dev V3
sudo ip netns exec N2 ip route add 10.0.40.0/24 via 10.0.20.22 dev V3
sudo ip netns exec N2 ip route add 10.0.50.0/24 via 10.0.20.22 dev V3
sudo ip netns exec N2 ip route add 10.0.60.0/24 via 10.0.20.22 dev V3

#handle routes for N3
sudo ip netns exec N3 ip route add 10.0.10.0/24 via 10.0.30.22 dev V5
sudo ip netns exec N3 ip route add 10.0.40.0/24 via 10.0.30.22 dev V5
sudo ip netns exec N3 ip route add 10.0.50.0/24 via 10.0.30.22 dev V5
sudo ip netns exec N3 ip route add 10.0.60.0/24 via 10.0.30.22 dev V5

#handle routes for N4
sudo ip netns exec N4 ip route add 10.0.10.0/24 via 10.0.40.22 dev V7
sudo ip netns exec N4 ip route add 10.0.20.0/24 via 10.0.40.22 dev V7
sudo ip netns exec N4 ip route add 10.0.50.0/24 via 10.0.40.22 dev V7
sudo ip netns exec N4 ip route add 10.0.60.0/24 via 10.0.40.22 dev V7

#handle routes for N5
sudo ip netns exec N5 ip route add 10.0.10.0/24 via 10.0.50.22 dev V9
sudo ip netns exec N5 ip route add 10.0.20.0/24 via 10.0.50.22 dev V9
sudo ip netns exec N5 ip route add 10.0.30.0/24 via 10.0.50.22 dev V9
sudo ip netns exec N5 ip route add 10.0.60.0/24 via 10.0.50.22 dev V9

#handle routes for N6
sudo ip netns exec N6 ip route add 10.0.10.0/24 via 10.0.60.22 dev V11
sudo ip netns exec N6 ip route add 10.0.20.0/24 via 10.0.60.22 dev V11
sudo ip netns exec N6 ip route add 10.0.30.0/24 via 10.0.60.22 dev V11
sudo ip netns exec N6 ip route add 10.0.40.0/24 via 10.0.60.22 dev V11



#*************************************************************************


#now ping all intefaces from individual namespaces

#ping all from N1
echo -e "${CYAN}PINGING EVERY INTERFACE FROM N1....${NC}"
echo 
echo -e "${ORANGE}Pinging V1 from N1...${NC}"
sudo ip netns exec N1 ping -c3 10.0.10.21
# echo -e "${GREEN}Successfull :)${NC}"
echo

echo -e "${ORANGE}Pinging V2 from N1...${NC}"
sudo ip netns exec N1 ping -c3 10.0.10.22
# echo -e "${GREEN}Successfull :)${NC}"
echo

echo -e "${ORANGE}Pinging V3 from N1...${NC}"
sudo ip netns exec N1 ping -c3 10.0.20.21
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V4 from N1...${NC}"
sudo ip netns exec N1 ping -c3 10.0.20.22
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V5 from N1...${NC}"
sudo ip netns exec N1 ping -c3 10.0.30.21
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V6 from N1...${NC}"
sudo ip netns exec N1 ping -c3 10.0.30.22
# echo -e "${GREEN}Successfull :)${NC}"
echo 
echo -e "${ORANGE}Pinging V7 from N1...${NC}"
sudo ip netns exec N1 ping -c3 10.0.40.21
# echo -e "${GREEN}Successfull :)${NC}"
echo

echo -e "${ORANGE}Pinging V8 from N1...${NC}"
sudo ip netns exec N1 ping -c3 10.0.40.22
# echo -e "${GREEN}Successfull :)${NC}"
echo

echo -e "${ORANGE}Pinging V9 from N1...${NC}"
sudo ip netns exec N1 ping -c3 10.0.50.21
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V10 from N1...${NC}"
sudo ip netns exec N1 ping -c3 10.0.50.22
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V11 from N1...${NC}"
sudo ip netns exec N1 ping -c3 10.0.60.21
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V12 from N1...${NC}"
sudo ip netns exec N1 ping -c3 10.0.60.22
# echo -e "${GREEN}Successfull :)${NC}"
echo 


#ping all from N2
echo -e "${CYAN}PINGING EVERY INTERFACE FROM N2....${NC}"
echo 
echo -e "${ORANGE}Pinging V1 from N2...${NC}"
sudo ip netns exec N2 ping -c3 10.0.10.21
# echo -e "${GREEN}Successfull :)${NC}"
echo

echo -e "${ORANGE}Pinging V2 from N2...${NC}"
sudo ip netns exec N2 ping -c3 10.0.10.22
# echo -e "${GREEN}Successfull :)${NC}"
echo

echo -e "${ORANGE}Pinging V3 from N2...${NC}"
sudo ip netns exec N2 ping -c3 10.0.20.21
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V4 from N2...${NC}"
sudo ip netns exec N2 ping -c3 10.0.20.22
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V5 from N2...${NC}"
sudo ip netns exec N2 ping -c3 10.0.30.21
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V6 from N2...${NC}"
sudo ip netns exec N2 ping -c3 10.0.30.22
# echo -e "${GREEN}Successfull :)${NC}"
echo 
echo -e "${ORANGE}Pinging V7 from N2...${NC}"
sudo ip netns exec N2 ping -c3 10.0.40.21
# echo -e "${GREEN}Successfull :)${NC}"
echo

echo -e "${ORANGE}Pinging V8 from N2...${NC}"
sudo ip netns exec N2 ping -c3 10.0.40.22
# echo -e "${GREEN}Successfull :)${NC}"
echo

echo -e "${ORANGE}Pinging V9 from N2...${NC}"
sudo ip netns exec N2 ping -c3 10.0.50.21
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V10 from N2...${NC}"
sudo ip netns exec N2 ping -c3 10.0.50.22
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V11 from N2...${NC}"
sudo ip netns exec N2 ping -c3 10.0.60.21
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V12 from N2...${NC}"
sudo ip netns exec N2 ping -c3 10.0.60.22
# echo -e "${GREEN}Successfull :)${NC}"
echo 


#ping all from N3
echo -e "${CYAN}PINGING EVERY INTERFACE FROM N3....${NC}"
echo 
echo -e "${ORANGE}Pinging V1 from N3...${NC}"
sudo ip netns exec N3 ping -c3 10.0.10.21
# echo -e "${GREEN}Successfull :)${NC}"
echo

echo -e "${ORANGE}Pinging V2 from N3...${NC}"
sudo ip netns exec N3 ping -c3 10.0.10.22
# echo -e "${GREEN}Successfull :)${NC}"
echo

echo -e "${ORANGE}Pinging V3 from N3...${NC}"
sudo ip netns exec N3 ping -c3 10.0.20.21
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V4 from N3...${NC}"
sudo ip netns exec N3 ping -c3 10.0.20.22
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V5 from N3...${NC}"
sudo ip netns exec N3 ping -c3 10.0.30.21
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V6 from N3...${NC}"
sudo ip netns exec N3 ping -c3 10.0.30.22
# echo -e "${GREEN}Successfull :)${NC}"
echo 
echo -e "${ORANGE}Pinging V7 from N3...${NC}"
sudo ip netns exec N3 ping -c3 10.0.40.21
# echo -e "${GREEN}Successfull :)${NC}"
echo

echo -e "${ORANGE}Pinging V8 from N3...${NC}"
sudo ip netns exec N3 ping -c3 10.0.40.22
# echo -e "${GREEN}Successfull :)${NC}"
echo

echo -e "${ORANGE}Pinging V9 from N3...${NC}"
sudo ip netns exec N3 ping -c3 10.0.50.21
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V10 from N3...${NC}"
sudo ip netns exec N3 ping -c3 10.0.50.22
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V11 from N3...${NC}"
sudo ip netns exec N3 ping -c3 10.0.60.21
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V12 from N3...${NC}"
sudo ip netns exec N3 ping -c3 10.0.60.22
# echo -e "${GREEN}Successfull :)${NC}"
echo 


#ping all from N4
echo -e "${CYAN}PINGING EVERY INTERFACE FROM N4....${NC}"
echo 
echo -e "${ORANGE}Pinging V1 from N4...${NC}"
sudo ip netns exec N4 ping -c3 10.0.10.21
# echo -e "${GREEN}Successfull :)${NC}"
echo

echo -e "${ORANGE}Pinging V2 from N4...${NC}"
sudo ip netns exec N4 ping -c3 10.0.10.22
# echo -e "${GREEN}Successfull :)${NC}"
echo

echo -e "${ORANGE}Pinging V3 from N4...${NC}"
sudo ip netns exec N4 ping -c3 10.0.20.21
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V4 from N4...${NC}"
sudo ip netns exec N4 ping -c3 10.0.20.22
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V5 from N4...${NC}"
sudo ip netns exec N4 ping -c3 10.0.30.21
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V6 from N4...${NC}"
sudo ip netns exec N4 ping -c3 10.0.30.22
# echo -e "${GREEN}Successfull :)${NC}"
echo 
echo -e "${ORANGE}Pinging V7 from N4...${NC}"
sudo ip netns exec N4 ping -c3 10.0.40.21
# echo -e "${GREEN}Successfull :)${NC}"
echo

echo -e "${ORANGE}Pinging V8 from N4...${NC}"
sudo ip netns exec N4 ping -c3 10.0.40.22
# echo -e "${GREEN}Successfull :)${NC}"
echo

echo -e "${ORANGE}Pinging V9 from N4...${NC}"
sudo ip netns exec N4 ping -c3 10.0.50.21
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V10 from N4...${NC}"
sudo ip netns exec N4 ping -c3 10.0.50.22
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V11 from N4...${NC}"
sudo ip netns exec N4 ping -c3 10.0.60.21
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V12 from N4...${NC}"
sudo ip netns exec N4 ping -c3 10.0.60.22
# echo -e "${GREEN}Successfull :)${NC}"
echo 


#ping all from N5
echo -e "${CYAN}PINGING EVERY INTERFACE FROM N5....${NC}"
echo 
echo -e "${ORANGE}Pinging V1 from N5...${NC}"
sudo ip netns exec N5 ping -c3 10.0.10.21
# echo -e "${GREEN}Successfull :)${NC}"
echo

echo -e "${ORANGE}Pinging V2 from N5...${NC}"
sudo ip netns exec N5 ping -c3 10.0.10.22
# echo -e "${GREEN}Successfull :)${NC}"
echo

echo -e "${ORANGE}Pinging V3 from N5...${NC}"
sudo ip netns exec N5 ping -c3 10.0.20.21
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V4 from N5...${NC}"
sudo ip netns exec N5 ping -c3 10.0.20.22
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V5 from N5...${NC}"
sudo ip netns exec N5 ping -c3 10.0.30.21
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V6 from N5...${NC}"
sudo ip netns exec N5 ping -c3 10.0.30.22
# echo -e "${GREEN}Successfull :)${NC}"
echo 
echo -e "${ORANGE}Pinging V7 from N5...${NC}"
sudo ip netns exec N5 ping -c3 10.0.40.21
# echo -e "${GREEN}Successfull :)${NC}"
echo

echo -e "${ORANGE}Pinging V8 from N5...${NC}"
sudo ip netns exec N5 ping -c3 10.0.40.22
# echo -e "${GREEN}Successfull :)${NC}"
echo

echo -e "${ORANGE}Pinging V9 from N5...${NC}"
sudo ip netns exec N5 ping -c3 10.0.50.21
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V10 from N5...${NC}"
sudo ip netns exec N5 ping -c3 10.0.50.22
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V11 from N5...${NC}"
sudo ip netns exec N5 ping -c3 10.0.60.21
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V12 from N5...${NC}"
sudo ip netns exec N5 ping -c3 10.0.60.22
# echo -e "${GREEN}Successfull :)${NC}"
echo 


#ping all from N6
echo -e "${CYAN}PINGING EVERY INTERFACE FROM N6....${NC}"
echo 
echo -e "${ORANGE}Pinging V1 from N6...${NC}"
sudo ip netns exec N6 ping -c3 10.0.10.21
# echo -e "${GREEN}Successfull :)${NC}"
echo

echo -e "${ORANGE}Pinging V2 from N6...${NC}"
sudo ip netns exec N6 ping -c3 10.0.10.22
# echo -e "${GREEN}Successfull :)${NC}"
echo

echo -e "${ORANGE}Pinging V3 from N6...${NC}"
sudo ip netns exec N6 ping -c3 10.0.20.21
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V4 from N6...${NC}"
sudo ip netns exec N6 ping -c3 10.0.20.22
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V5 from N6...${NC}"
sudo ip netns exec N6 ping -c3 10.0.30.21
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V6 from N6...${NC}"
sudo ip netns exec N6 ping -c3 10.0.30.22
# echo -e "${GREEN}Successfull :)${NC}"
echo 
echo -e "${ORANGE}Pinging V7 from N6...${NC}"
sudo ip netns exec N6 ping -c3 10.0.40.21
# echo -e "${GREEN}Successfull :)${NC}"
echo

echo -e "${ORANGE}Pinging V8 from N6...${NC}"
sudo ip netns exec N6 ping -c3 10.0.40.22
# echo -e "${GREEN}Successfull :)${NC}"
echo

echo -e "${ORANGE}Pinging V9 from N6...${NC}"
sudo ip netns exec N6 ping -c3 10.0.50.21
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V10 from N6...${NC}"
sudo ip netns exec N6 ping -c3 10.0.50.22
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V11 from N6...${NC}"
sudo ip netns exec N6 ping -c3 10.0.60.21
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V12 from N6...${NC}"
sudo ip netns exec N6 ping -c3 10.0.60.22
# echo -e "${GREEN}Successfull :)${NC}"
echo 


#*******************************************************************
echo -e "${CYAN}TRACEROUTE CHECKING.....${NC}"
echo 
echo -e "${GREEN}Traceroute from N1 to N5 (V9 in V5)...${NC}"
sudo ip netns exec N1 traceroute 10.0.50.21
echo 
sudo sleep 3
echo -e "${GREEN}Traceroute from N3 to N5 (V9 in N5)...${NC}"
sudo ip netns exec N3 traceroute 10.0.50.21
echo 
sudo sleep 3
echo -e "${GREEN}Traceroute from N3 to N1 (V1 in N1)...${NC}"
sudo ip netns exec N3 traceroute 10.0.10.21
echo 


#********************************************************************