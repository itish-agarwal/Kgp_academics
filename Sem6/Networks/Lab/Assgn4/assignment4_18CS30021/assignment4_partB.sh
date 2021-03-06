#! /bin/bash

CYAN='\033[1;36m'
ORANGE='\033[1;33m'
GREEN=`tput setaf 118`
NC='\033[0m' # No Color

#create the namespaces
sudo ip netns add H1
sudo ip netns add H2
sudo ip netns add H3
sudo ip netns add H4
sudo ip netns add R1
sudo ip netns add R2
sudo ip netns add R3


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



# attach V1 to H1
sudo ip link set V1 netns H1
# attach V2 to R1
sudo ip link set V2 netns R1
# attach V3 to H2
sudo ip link set V3 netns H2
# attach V4 to R1
sudo ip link set V4 netns R1
# attach V5 to R1
sudo ip link set V5 netns R1
# attach V6 to R2
sudo ip link set V6 netns R2
# attach V7 to R2
sudo ip link set V7 netns R2
# attach V8 to R3
sudo ip link set V8 netns R3
# attach V9 to R3
sudo ip link set V9 netns R3
# attach V10 to H3
sudo ip link set V10 netns H3
# attach V11 to R3
sudo ip link set V11 netns R3
# attach V12 to H4
sudo ip link set V12 netns H4




#assign ip addresses to veths
sudo ip netns exec H1 ip addr add 10.0.10.21/24 dev V1
sudo ip netns exec H1 ip link set dev V1 up

sudo ip netns exec R1 ip addr add 10.0.10.22/24 dev V2
sudo ip netns exec R1 ip link set dev V2 up

sudo ip netns exec H2 ip addr add 10.0.20.21/24 dev V3
sudo ip netns exec H2 ip link set dev V3 up

sudo ip netns exec R1 ip addr add 10.0.20.22/24 dev V4
sudo ip netns exec R1 ip link set dev V4 up

sudo ip netns exec R1 ip addr add 10.0.30.21/24 dev V5
sudo ip netns exec R1 ip link set dev V5 up

sudo ip netns exec R2 ip addr add 10.0.30.22/24 dev V6
sudo ip netns exec R2 ip link set dev V6 up

sudo ip netns exec R2 ip addr add 10.0.40.21/24 dev V7
sudo ip netns exec R2 ip link set dev V7 up

sudo ip netns exec R3 ip addr add 10.0.40.22/24 dev V8
sudo ip netns exec R3 ip link set dev V8 up

sudo ip netns exec R3 ip addr add 10.0.50.21/24 dev V9
sudo ip netns exec R3 ip link set dev V9 up

sudo ip netns exec H3 ip addr add 10.0.50.22/24 dev V10
sudo ip netns exec H3 ip link set dev V10 up

sudo ip netns exec R3 ip addr add 10.0.60.21/24 dev V11
sudo ip netns exec R3 ip link set dev V11 up

sudo ip netns exec H4 ip addr add 10.0.60.22/24 dev V12
sudo ip netns exec H4 ip link set dev V12 up


#******************************************************************

#enable loopback interface at each namespace (so that a namespace can ping its own interfaces)
sudo ip -n H1 link set lo up
sudo ip -n H2 link set lo up
sudo ip -n H3 link set lo up
sudo ip -n H4 link set lo up
sudo ip -n R1 link set lo up
sudo ip -n R2 link set lo up
sudo ip -n R3 link set lo up

#enable ip forwarding at R1, R2, R3
sudo ip netns exec R1 sysctl -w net.ipv4.ip_forward=1
sudo ip netns exec R2 sysctl -w net.ipv4.ip_forward=1
sudo ip netns exec R3 sysctl -w net.ipv4.ip_forward=1

#*******************************************************************

#handle routes for H1
sudo ip netns exec H1 ip route add 10.0.20.0/24 via 10.0.10.22 dev V1
sudo ip netns exec H1 ip route add 10.0.30.0/24 via 10.0.10.22 dev V1
sudo ip netns exec H1 ip route add 10.0.40.0/24 via 10.0.10.22 dev V1
sudo ip netns exec H1 ip route add 10.0.50.0/24 via 10.0.10.22 dev V1
sudo ip netns exec H1 ip route add 10.0.60.0/24 via 10.0.10.22 dev V1

#handle routes for R1
sudo ip netns exec R1 ip route add 10.0.40.0/24 via 10.0.30.22 dev V5
sudo ip netns exec R1 ip route add 10.0.50.0/24 via 10.0.30.22 dev V5
sudo ip netns exec R1 ip route add 10.0.60.0/24 via 10.0.30.22 dev V5

# #handle routes for H2
sudo ip netns exec H2 ip route add 10.0.10.0/24 via 10.0.20.22 dev V3
sudo ip netns exec H2 ip route add 10.0.30.0/24 via 10.0.20.22 dev V3
sudo ip netns exec H2 ip route add 10.0.40.0/24 via 10.0.20.22 dev V3
sudo ip netns exec H2 ip route add 10.0.50.0/24 via 10.0.20.22 dev V3
sudo ip netns exec H2 ip route add 10.0.60.0/24 via 10.0.20.22 dev V3

# #handle routes for R2
sudo ip netns exec R2 ip route add 10.0.10.0/24 via 10.0.30.21 dev V6
sudo ip netns exec R2 ip route add 10.0.20.0/24 via 10.0.30.21 dev V6
sudo ip netns exec R2 ip route add 10.0.50.0/24 via 10.0.40.22 dev V7
sudo ip netns exec R2 ip route add 10.0.60.0/24 via 10.0.40.22 dev V7

# #handle routes for R3
sudo ip netns exec R3 ip route add 10.0.10.0/24 via 10.0.40.21 dev V8
sudo ip netns exec R3 ip route add 10.0.20.0/24 via 10.0.40.21 dev V8
sudo ip netns exec R3 ip route add 10.0.30.0/24 via 10.0.40.21 dev V8

# #handle routes for H3
sudo ip netns exec H3 ip route add 10.0.10.0/24 via 10.0.50.21 dev V10
sudo ip netns exec H3 ip route add 10.0.20.0/24 via 10.0.50.21 dev V10
sudo ip netns exec H3 ip route add 10.0.30.0/24 via 10.0.50.21 dev V10
sudo ip netns exec H3 ip route add 10.0.40.0/24 via 10.0.50.21 dev V10
sudo ip netns exec H3 ip route add 10.0.60.0/24 via 10.0.50.21 dev V10

# #handle routes for H4
sudo ip netns exec H4 ip route add 10.0.10.0/24 via 10.0.60.21 dev V12
sudo ip netns exec H4 ip route add 10.0.20.0/24 via 10.0.60.21 dev V12
sudo ip netns exec H4 ip route add 10.0.30.0/24 via 10.0.60.21 dev V12
sudo ip netns exec H4 ip route add 10.0.40.0/24 via 10.0.60.21 dev V12
sudo ip netns exec H4 ip route add 10.0.50.0/24 via 10.0.60.21 dev V12

#*************************************************************************




#now ping all intefaces from individual namespaces

#ping all from H1
echo -e "${CYAN}PINGING EVERY INTERFACE FROM H1....${NC}"
echo 
echo -e "${ORANGE}Pinging V1 from H1...${NC}"
sudo ip netns exec H1 ping -c3 10.0.10.21
# echo -e "${GREEN}Successfull :)${NC}"
echo

echo -e "${ORANGE}Pinging V2 from H1...${NC}"
sudo ip netns exec H1 ping -c3 10.0.10.22
# echo -e "${GREEN}Successfull :)${NC}"
echo

echo -e "${ORANGE}Pinging V3 from H1...${NC}"
sudo ip netns exec H1 ping -c3 10.0.20.21
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V4 from H1...${NC}"
sudo ip netns exec H1 ping -c3 10.0.20.22
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V5 from H1...${NC}"
sudo ip netns exec H1 ping -c3 10.0.30.21
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V6 from H1...${NC}"
sudo ip netns exec H1 ping -c3 10.0.30.22
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V7 from H1...${NC}"
sudo ip netns exec H1 ping -c3 10.0.40.21
# echo -e "${GREEN}Successfull :)${NC}"
echo

echo -e "${ORANGE}Pinging V8 from H1...${NC}"
sudo ip netns exec H1 ping -c3 10.0.40.22
# echo -e "${GREEN}Successfull :)${NC}"
echo

echo -e "${ORANGE}Pinging V9 from H1...${NC}"
sudo ip netns exec H1 ping -c3 10.0.50.21
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V10 from H1...${NC}"
sudo ip netns exec H1 ping -c3 10.0.50.22
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V11 from H1...${NC}"
sudo ip netns exec H1 ping -c3 10.0.60.21
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V12 from H1...${NC}"
sudo ip netns exec H1 ping -c3 10.0.60.22
# echo -e "${GREEN}Successfull :)${NC}"
echo 



#ping all from H2
echo -e "${CYAN}PINGING EVERY INTERFACE FROM H2....${NC}"
echo 
echo -e "${ORANGE}Pinging V1 from H2...${NC}"
sudo ip netns exec H2 ping -c3 10.0.10.21
# echo -e "${GREEN}Successfull :)${NC}"
echo

echo -e "${ORANGE}Pinging V2 from H2...${NC}"
sudo ip netns exec H2 ping -c3 10.0.10.22
# echo -e "${GREEN}Successfull :)${NC}"
echo

echo -e "${ORANGE}Pinging V3 from H2...${NC}"
sudo ip netns exec H2 ping -c3 10.0.20.21
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V4 from H2...${NC}"
sudo ip netns exec H2 ping -c3 10.0.20.22
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V5 from H2...${NC}"
sudo ip netns exec H2 ping -c3 10.0.30.21
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V6 from H2...${NC}"
sudo ip netns exec H2 ping -c3 10.0.30.22
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V7 from H2...${NC}"
sudo ip netns exec H2 ping -c3 10.0.40.21
# echo -e "${GREEN}Successfull :)${NC}"
echo

echo -e "${ORANGE}Pinging V8 from H2...${NC}"
sudo ip netns exec H2 ping -c3 10.0.40.22
# echo -e "${GREEN}Successfull :)${NC}"
echo

echo -e "${ORANGE}Pinging V9 from H2...${NC}"
sudo ip netns exec H2 ping -c3 10.0.50.21
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V10 from H2...${NC}"
sudo ip netns exec H2 ping -c3 10.0.50.22
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V11 from H2...${NC}"
sudo ip netns exec H2 ping -c3 10.0.60.21
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V12 from H2...${NC}"
sudo ip netns exec H2 ping -c3 10.0.60.22
# echo -e "${GREEN}Successfull :)${NC}"
echo 



#ping all from H3
echo -e "${CYAN}PINGING EVERY INTERFACE FROM H3....${NC}"
echo 
echo -e "${ORANGE}Pinging V1 from H3...${NC}"
sudo ip netns exec H3 ping -c3 10.0.10.21
# echo -e "${GREEN}Successfull :)${NC}"
echo

echo -e "${ORANGE}Pinging V2 from H3...${NC}"
sudo ip netns exec H3 ping -c3 10.0.10.22
# echo -e "${GREEN}Successfull :)${NC}"
echo

echo -e "${ORANGE}Pinging V3 from H3...${NC}"
sudo ip netns exec H3 ping -c3 10.0.20.21
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V4 from H3...${NC}"
sudo ip netns exec H3 ping -c3 10.0.20.22
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V5 from H3...${NC}"
sudo ip netns exec H3 ping -c3 10.0.30.21
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V6 from H3...${NC}"
sudo ip netns exec H3 ping -c3 10.0.30.22
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V7 from H3...${NC}"
sudo ip netns exec H3 ping -c3 10.0.40.21
# echo -e "${GREEN}Successfull :)${NC}"
echo

echo -e "${ORANGE}Pinging V8 from H3...${NC}"
sudo ip netns exec H3 ping -c3 10.0.40.22
# echo -e "${GREEN}Successfull :)${NC}"
echo

echo -e "${ORANGE}Pinging V9 from H3...${NC}"
sudo ip netns exec H3 ping -c3 10.0.50.21
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V10 from H3...${NC}"
sudo ip netns exec H3 ping -c3 10.0.50.22
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V11 from H3...${NC}"
sudo ip netns exec H3 ping -c3 10.0.60.21
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V12 from H3...${NC}"
sudo ip netns exec H3 ping -c3 10.0.60.22
# echo -e "${GREEN}Successfull :)${NC}"
echo 


#ping all from H4
echo -e "${CYAN}PINGING EVERY INTERFACE FROM H4....${NC}"
echo 
echo -e "${ORANGE}Pinging V1 from H4...${NC}"
sudo ip netns exec H4 ping -c3 10.0.10.21
# echo -e "${GREEN}Successfull :)${NC}"
echo

echo -e "${ORANGE}Pinging V2 from H4...${NC}"
sudo ip netns exec H4 ping -c3 10.0.10.22
# echo -e "${GREEN}Successfull :)${NC}"
echo

echo -e "${ORANGE}Pinging V3 from H4...${NC}"
sudo ip netns exec H4 ping -c3 10.0.20.21
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V4 from H4...${NC}"
sudo ip netns exec H4 ping -c3 10.0.20.22
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V5 from H4...${NC}"
sudo ip netns exec H4 ping -c3 10.0.30.21
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V6 from H4...${NC}"
sudo ip netns exec H4 ping -c3 10.0.30.22
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V7 from H4...${NC}"
sudo ip netns exec H4 ping -c3 10.0.40.21
# echo -e "${GREEN}Successfull :)${NC}"
echo

echo -e "${ORANGE}Pinging V8 from H4...${NC}"
sudo ip netns exec H4 ping -c3 10.0.40.22
# echo -e "${GREEN}Successfull :)${NC}"
echo

echo -e "${ORANGE}Pinging V9 from H4...${NC}"
sudo ip netns exec H4 ping -c3 10.0.50.21
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V10 from H4...${NC}"
sudo ip netns exec H4 ping -c3 10.0.50.22
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V11 from H4...${NC}"
sudo ip netns exec H4 ping -c3 10.0.60.21
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V12 from H4...${NC}"
sudo ip netns exec H4 ping -c3 10.0.60.22
# echo -e "${GREEN}Successfull :)${NC}"
echo 



#ping all from R1
echo -e "${CYAN}PINGING EVERY INTERFACE FROM R1....${NC}"
echo 
echo -e "${ORANGE}Pinging V1 from R1...${NC}"
sudo ip netns exec R1 ping -c3 10.0.10.21
# echo -e "${GREEN}Successfull :)${NC}"
echo

echo -e "${ORANGE}Pinging V2 from R1...${NC}"
sudo ip netns exec R1 ping -c3 10.0.10.22
# echo -e "${GREEN}Successfull :)${NC}"
echo

echo -e "${ORANGE}Pinging V3 from R1...${NC}"
sudo ip netns exec R1 ping -c3 10.0.20.21
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V4 from R1...${NC}"
sudo ip netns exec R1 ping -c3 10.0.20.22
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V5 from R1...${NC}"
sudo ip netns exec R1 ping -c3 10.0.30.21
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V6 from R1...${NC}"
sudo ip netns exec R1 ping -c3 10.0.30.22
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V7 from R1...${NC}"
sudo ip netns exec R1 ping -c3 10.0.40.21
# echo -e "${GREEN}Successfull :)${NC}"
echo

echo -e "${ORANGE}Pinging V8 from R1...${NC}"
sudo ip netns exec R1 ping -c3 10.0.40.22
# echo -e "${GREEN}Successfull :)${NC}"
echo

echo -e "${ORANGE}Pinging V9 from R1...${NC}"
sudo ip netns exec R1 ping -c3 10.0.50.21
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V10 from R1...${NC}"
sudo ip netns exec R1 ping -c3 10.0.50.22
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V11 from R1...${NC}"
sudo ip netns exec R1 ping -c3 10.0.60.21
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V12 from R1...${NC}"
sudo ip netns exec R1 ping -c3 10.0.60.22
# echo -e "${GREEN}Successfull :)${NC}"
echo 


#ping all from R2
echo -e "${CYAN}PINGING EVERY INTERFACE FROM R2....${NC}"
echo 
echo -e "${ORANGE}Pinging V1 from R2...${NC}"
sudo ip netns exec R2 ping -c3 10.0.10.21
# echo -e "${GREEN}Successfull :)${NC}"
echo

echo -e "${ORANGE}Pinging V2 from R2...${NC}"
sudo ip netns exec R2 ping -c3 10.0.10.22
# echo -e "${GREEN}Successfull :)${NC}"
echo

echo -e "${ORANGE}Pinging V3 from R2...${NC}"
sudo ip netns exec R2 ping -c3 10.0.20.21
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V4 from R2...${NC}"
sudo ip netns exec R2 ping -c3 10.0.20.22
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V5 from R2...${NC}"
sudo ip netns exec R2 ping -c3 10.0.30.21
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V6 from R2...${NC}"
sudo ip netns exec R2 ping -c3 10.0.30.22
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V7 from R2...${NC}"
sudo ip netns exec R2 ping -c3 10.0.40.21
# echo -e "${GREEN}Successfull :)${NC}"
echo

echo -e "${ORANGE}Pinging V8 from R2...${NC}"
sudo ip netns exec R2 ping -c3 10.0.40.22
# echo -e "${GREEN}Successfull :)${NC}"
echo

echo -e "${ORANGE}Pinging V9 from R2...${NC}"
sudo ip netns exec R2 ping -c3 10.0.50.21
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V10 from R2...${NC}"
sudo ip netns exec R2 ping -c3 10.0.50.22
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V11 from R2...${NC}"
sudo ip netns exec R2 ping -c3 10.0.60.21
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V12 from R2...${NC}"
sudo ip netns exec R2 ping -c3 10.0.60.22
# echo -e "${GREEN}Successfull :)${NC}"
echo 


#ping all from R3
echo -e "${CYAN}PINGING EVERY INTERFACE FROM R3....${NC}"
echo 
echo -e "${ORANGE}Pinging V1 from R3...${NC}"
sudo ip netns exec R3 ping -c3 10.0.10.21
# echo -e "${GREEN}Successfull :)${NC}"
echo

echo -e "${ORANGE}Pinging V2 from R3...${NC}"
sudo ip netns exec R3 ping -c3 10.0.10.22
# echo -e "${GREEN}Successfull :)${NC}"
echo

echo -e "${ORANGE}Pinging V3 from R3...${NC}"
sudo ip netns exec R3 ping -c3 10.0.20.21
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V4 from R3...${NC}"
sudo ip netns exec R3 ping -c3 10.0.20.22
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V5 from R3...${NC}"
sudo ip netns exec R3 ping -c3 10.0.30.21
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V6 from R3...${NC}"
sudo ip netns exec R3 ping -c3 10.0.30.22
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V7 from R3...${NC}"
sudo ip netns exec R3 ping -c3 10.0.40.21
# echo -e "${GREEN}Successfull :)${NC}"
echo

echo -e "${ORANGE}Pinging V8 from R3...${NC}"
sudo ip netns exec R3 ping -c3 10.0.40.22
# echo -e "${GREEN}Successfull :)${NC}"
echo

echo -e "${ORANGE}Pinging V9 from R3...${NC}"
sudo ip netns exec R3 ping -c3 10.0.50.21
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V10 from R3...${NC}"
sudo ip netns exec R3 ping -c3 10.0.50.22
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V11 from R3...${NC}"
sudo ip netns exec R3 ping -c3 10.0.60.21
# echo -e "${GREEN}Successfull :)${NC}"
echo 

echo -e "${ORANGE}Pinging V12 from R3...${NC}"
sudo ip netns exec R3 ping -c3 10.0.60.22
# echo -e "${GREEN}Successfull :)${NC}"
echo 


#*******************************************************************
echo -e "${CYAN}TRACEROUTE CHECKING.....${NC}"
echo 
echo -e "${GREEN}Traceroute from H1 to H4...${NC}"
sudo ip netns exec H1 traceroute 10.0.60.22
echo 
sudo sleep 2
echo -e "${GREEN}Traceroute from H3 to H4...${NC}"
sudo ip netns exec H3 traceroute 10.0.60.22
echo 
sudo sleep 2
echo -e "${GREEN}Traceroute from H4 to H2...${NC}"
sudo ip netns exec H4 traceroute 10.0.20.21
echo 

#********************************************************************