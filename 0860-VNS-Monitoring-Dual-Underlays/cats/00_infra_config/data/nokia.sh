#!/bin/bash

# Script pour utiliser Netem
# version 2.0 du 24 aout 2018
# Ecrit par MDR
# Reecrit par GB
# Customisation pour Workshop Nokia

function press_enter
{
    echo ""
    echo -n "Press Enter to continue"
    read
    clear
}

function banner
{
clear
    echo -e "\n"
    echo "*******************************************************"
    echo "**************   Nokia SD-WAN Simulation   **************"
    echo -e "*******************************************************\n\n\n"
}

function reset
{
banner
printf "\n\n\n\nRestarting simulation"
sleep 1
tc qdisc del dev eth0 root > /dev/null 2>&1
tc qdisc del dev eth1 root > /dev/null 2>&1
tc qdisc del dev eth2 root > /dev/null 2>&1
tc qdisc del dev eth3 root > /dev/null 2>&1
tc qdisc del dev eth4 root > /dev/null 2>&1
tc qdisc del dev eth5 root > /dev/null 2>&1
tc qdisc del dev eth6 root > /dev/null 2>&1

CLASSTAB_ETH1=(0)
CLASSTAB_ETH2=(0)
CLASSTAB_ETH3=(0)
CLASSTAB_ETH4=(0)
CLASSTAB_ETH5=(0)
printf "\n\nSimulation restarted !\n\n"
sleep 1
}

function service_provider
{
    service_provider=
    until [ "$service_provider" = "0" ]; do
    banner
    echo -e " NUAGE WAN Simulation settings : choose a link to modify\n\n"
    echo "1 - Internet Branch 1"
    echo "2 - Internet Branch 2"
    echo "3 - Internet Branch 3"
    echo "4 - Internet Branch 4"
    echo "5 - Internet Branch 5"
    echo ""
    echo "0 - return to main menu"
    echo ""
    echo -n "Enter selection: "
    read service_provider
    echo ""
    case $service_provider in
    		1 ) IF1=eth1 LINK=ETH1; netemaction ;;
		2 ) IF1=eth2 LINK=ETH2; netemaction ;;
		3 ) IF1=eth3 LINK=ETH3; netemaction ;;
		4 ) IF1=eth4 LINK=ETH4; netemaction ;;
		5 ) IF1=eth5 LINK=ETH5; netemaction ;;
       		0 ) menu ;;
        * ) echo "Please enter a number in the range [1 - 5], or 0"; press_enter
    esac
done
}

function netemaction
{
    netemaction=
    until [ "$netemaction" = "0" ]; do
    banner
    echo -e "     IWAN WAN Simulation settings : choose Action\n\n\n"
    echo "1 - loss"
    echo "2 - delay"
    echo ""
    echo "0 - return to main menu"
    echo ""
    echo -n "Enter selection: "
    read netemaction
    echo ""
    case $netemaction in
        1 ) NETEM1=loss ; netemparam ;;
        2 ) NETEM1=delay ; netemparam ;;
        0 ) menu ;;
        * ) echo "Please enter 1, 2, or 0"; press_enter
    esac
done
}

function netemparam
{
    banner
    echo -e "IWAN WAN Simulation settings : choose Action Parameter\n\n\n"
    echo -n "Enter parameter: "
    read NETEM2
    echo ""
    simulation
    menu
}

function simulation
{

# on entre dans la logique d'ajout/modification des regles NETEM sur les interfaces
# on a un delta de 1 entre le numero entre par l'utilisateur et l'index du tableau qui commence a 0


# on regarde dans le tableau qui correspond a la liaison traitee si on a deja une regle pour le
# DSCP selectionne (valeur a 1)
#echo "CLASSTAB_LINK= $LINK $((CLASSTAB_$LINK[0]))"
if [ $((CLASSTAB_$LINK[0])) = 1 ]; then

	# si on a deja une regle, on la change
        echo "je passe dans change $IF1 ${NETEM1} ${NETEM2}"
        tc qdisc change dev $IF1 root netem ${NETEM1} ${NETEM2}  > /dev/null 2>&1
        echo "je passe dans change" > /dev/null 2>&1
        echo -n "Configuration in progress"
        for ((i=0 ; 3 - $i ; i++))
        do
                echo -n .
                sleep 1
        done

# si pas de regle en cours, on en cree une

else
        tc qdisc add dev $IF1 root netem ${NETEM1} ${NETEM2}  > /dev/null 2>&1
	eval "CLASSTAB_$LINK[0]=1"
#echo "CLASSTAB_LINK= $LINK $((CLASSTAB_$LINK[0]))"
#        echo "je passe dans add $IF1 ${NETEM1} ${NETEM2}"
#        echo "je passe dans add" > /dev/null 2>&1
        echo -n "Configuration in progress"
        for ((i=0 ; 3 - $i ; i++))
        do
                echo -n .
                sleep 1
        done
fi
}

########################################################
# fonction qui donne le status des regles netem en cours
########################################################

function policy
{
clear

# on affichera l entete et la seule option sera de quitter

banner
	echo -e "            Displaying current Netem Policy \n\n\n"


	# on a 8 liaisons sur lesquelles on peut creer des regles
	# on va boucler sur les 8 liaisons pour connaitre les regles en cours
	for index in `seq 1 5`
		do

		# les 8 liaisons correspondent aux 8 eth du serveur de eth1 a eth8
		# on construit une string eth + index
((TMP = $index - 1 ))
echo ${LINKSTAB[$TMP]}
		ETH="eth$index"


			# on construit 3 morceaux de string pour affichage sans retour a la ligne pas trouve comment faire autrement
			# on grep sur plusieurs chaines et notamment la hierarchie HTB construite, la regle netem du DSCP
			# X est la regle 1X donc grep 1$DSCP_INDEX

			# premier chunk renvoie le nom du routeur et du lien, sed remplace ethX par RX + SPY
CHUNK1=$(tc qdisc show | grep "$ETH " | grep '[delay|loss]' | grep -v priomap | awk -F" " '{print $5}')

			# second chunk renvoie l'action netem en cours delay ou loss
CHUNK2=$(tc qdisc show | grep "$ETH " | grep '[delay|loss]' | grep -v priomap | awk -F" " '{print $11}')

			# troisieme chunk renvoie la valeur du parametre
CHUNK3=$(tc qdisc show | grep "$ETH " | grep '[delay|loss]' | grep -v priomap | awk -F" " '{print $12}')

			# on teste si le premier chunk est vide, alors pas de regle on affiche rien
			if [[ $CHUNK1 == "" ]]
				then
				echo "" > /dev/null 2>&1
				else

				# si on a une regle on l affiche et on ajoute egalement la valeur du DSCP
				# le tableau commence a zero donc on decremente l index DSCP de 1
				echo "$CHUNK1 $CHUNK2 $CHUNK3"
			fi
	done

	echo -e "\nplease press any key to return to main menu\n"
	read main_menu
    	case $main_menu in
        	* ) echo ""; menu
    	esac

}

########################################################
#  fonction qui retrouve les regles en place           #
########################################################

function init
{
LINKSTAB=("Internet_Branch1" "Internet_Branch2" "Internet_Branch3" "Internet_Branch4" "Internet_Branch5")
clear

# on a 8 liaisons sur lesquelles on peut creer des regles
# on va boucler sur les 8 liaisons pour connaitre les regles en cours
for index1 in `seq 1 5`
        do
	LINK=ETH$index1
	echo $LINK
        # les 8 liaisons correspondent aux 8 eth du serveur de eth1 a eth8
        # on construit une string eth + index

        ETH="eth$index1"

		# on remplit le tableau CLASSTAB de la liaison en cours d etude, la variable $LINK complete
		# le nom du tableau
TEST=$(tc qdisc show | grep "$ETH " | grep netem | grep -v priomap | wc -l)
eval "CLASSTAB_$LINK[0]=$TEST"
done
}



function menu
{
selection=
until [ "$selection" = "0" ]; do
    banner
    echo "1 - add/modify a new simulation policy"
    echo "2 - reset the simulation"
    echo "3 - print current netem policy"
    echo ""
    echo "0 - exit program"
    echo ""
    echo -n "Enter selection: "
    read selection
    echo ""
    case $selection in
        1 ) service_provider ;;
        2 ) reset ;;
        3 ) policy ;;
        0 ) exit ;;
        * ) echo "Please enter 1, 2, 3 or 0"; press_enter
    esac
done
}

############# PROGRAMME PRINCIPAL ##############

# on retrouve les valeurs netem en cours d utilisation

init

# on lance le menu

menu
