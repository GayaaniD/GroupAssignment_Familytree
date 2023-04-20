/ Edges
edge married;
edge child;
edge member;

// Nodes
node person {
    has id;
    has family_id;
    has name;
    has date_of_birth;
    has profession;
    has gender;
    has deceased;
    has parents;
    has children;
    has spouse;
    has age;
    has days_to_birthday;

    can get_age {
        today_date = date.date_now();
        difference = date.date_day_diff(start_date=date_of_birth, end_date=today_date);
        age = difference / 365;
    }

    can get_categorize{
        today_date = date.date_now();
        difference = date.date_day_diff(start_date=date_of_birth, end_date=today_date);
        age =difference / 365;

         if(age<5):category = "baby" ;
         elif(age<13):category = "child";
         elif(age<19):category = "Teenage";
         elif(age<39):category = "Adult";
         elif(age<54):category = "Middle_age";
         else:category = "elder";

    }
}
node family_root {
    has id;
    has family_name;
}

// Graphs
graph family_tree {
    has anchor family_root;
    spawn {
        family_root = spawn node::family_root;
    }
}
