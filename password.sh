#!/bin/bash



# This Script will Generate passeord or search a password
#sqlite3 test.db  "create table n (id INTEGER PRIMARY KEY,f TEXT NOT NULL,l TEXT);"
if [ -e MySafe.db ]
then
    echo ""
else
    sqlite3 MySafe.db  "create table Safe (id INTEGER PRIMARY KEY,ACCOUNT TEXT NOT NULL UNIQUE,EMAIL TEXT NOT NULL, USERNAME TEXT NOT NULL, PASSWORD TEXT NOT NULL, MOBILE PASSWORD TEXT);"
    echo " New Data Base Is Created "
fi


#check if there is a python script to generate the password and if not make one
#Chech if there is a sql table and if not make one
if [ -e generate_password  ]
then
    echo ""
else
    echo "import random" >> generate_password
    echo "letters = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z']">> generate_password
    echo "numbers = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']" >> generate_password
    echo "symbols = ['!', '#', '$', '%', '&', '(', ')', '*', '+']" >> generate_password

    echo "nr_letters = random.randint(8, 10)" >> generate_password
    echo "nr_symbols = random.randint(2, 4)" >> generate_password
    echo "nr_numbers = random.randint(2, 4)" >> generate_password

    echo "password_list = [random.choice(letters) for i in range(nr_letters)]" >> generate_password
    echo "password_list += [random.choice(symbols) for e in range(nr_symbols)]" >> generate_password
    echo "password_list += [random.choice(numbers) for k in range(nr_numbers)]" >> generate_password
    echo "random.shuffle(password_list)" >> generate_password

    echo 'password = "".join(password_list)' >> generate_password
    echo "print(password)" >> generate_password

    echo " New Python Auto Generator Is Created "
     
fi



# Case Statment 
#####################################################################################################################################################################
case $1 in 
    # Generate Password
    -g | --generate)

        # Check The User Password
        read -p "Enter Password: " user_password
        
        if [[ $user_password == "1234" ]]
        then

            python generate_password > value
            read -p "Enter The Account: " Account
            read -p "Enter The Username: " Username
            read -p "Enter The Email: " Email
            read -p "Enter The Mobile Number: " Mobile
            Password=$(<value)
            sqlite3 MySafe.db  "insert into Safe (ACCOUNT, EMAIL, USERNAME, PASSWORD, MOBILE) values ('$Account', '$Username', '$Email','$Password', '$Mobile');"

        else
            echo "Sorry You Are Not Authorized!"
        fi
    ;;


    # Search Pasword
    -s | --search )

        # Check The User Password
        read -p "Enter Password: " user_password

        if [[ $user_password == "1234" ]]
        then
            read -p "Enter The Account: " Account
            sqlite3 MySafe.db  -header -column  "select * from Safe where ACCOUNT is '$Account';"
            

        else
            echo "Sorry You Are Not Authorized!"
        fi
    ;;


 

    # ANY OTHER OPTION
    * )
        echo ""
        echo "Sorry You Didn't Specify an Option"
        echo "-------------------------------------------------------------------------------"
        echo "1) Use -c or --generate to generate a new password "
        echo "                  OR"
        echo "2) Use -s or --search to search for password "
        ;;
esac
