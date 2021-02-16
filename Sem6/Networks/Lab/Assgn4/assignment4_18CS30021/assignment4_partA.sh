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

#create a veth pair : v1-v2
sudo ip link add V1 type veth peer name V2

#create a veth pair : v3-v4
sudo ip link add V3 type veth peer name V4
 
#create a veth pair : v5-v6
sudo ip link add V5 type veth peer name V6
 

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


#**********************************************************************

#enable loopback interface at each namespace (so that a namespace can ping its own interfaces)
sudo ip -n N1 link set lo up
sudo ip -n N2 link set lo up
sudo ip -n N3 link set lo up
sudo ip -n N4 link set lo up

#enable ip forwarding at N2 and N3
sudo ip netns exec N2 sysctl -w net.ipv4.ip_forward=1
sudo ip netns exec N3 sysctl -w net.ipv4.ip_forward=1

#***********************************************************************


#handle routes for N1
sudo ip netns exec N1 ip route add 10.0.20.0/24 via 10.0.10.22 dev V1
sudo ip netns exec N1 ip route add 10.0.30.0/24 via 10.0.10.22 dev V1

#handle routes for N2
sudo ip netns exec N2 ip route add 10.0.30.0/24 via 10.0.20.22 dev V3

#handle routes for N3
sudo ip netns exec N3 ip route add 10.0.10.0/24 via 10.0.20.21 dev V4

#handle routes for N4
sudo ip netns exec N4 ip route add 10.0.10.0/24 via 10.0.30.21 dev V6
sudo ip netns exec N4 ip route add 10.0.20.0/24 via 10.0.30.21 dev V6






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




#ping all from N2
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

#***********************************************************************
