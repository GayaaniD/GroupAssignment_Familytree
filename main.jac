import {*} with "./graph.jac";

walker create_familytree {
    // creates a familytree from a json file
    has data_file = "familytree.json";
    has family_members = [];

    root {
        families = file.load_json(data_file)["families"];
        for family in families {
            spawn here ++> node::family_root(
                id = family["uid"],
                family_name = family["family_name"]
            );
        }
        take-->node::family_root;
    }

    family_root {
        family_id = here.id;
        members = file.load_json(data_file)["members"];
        for member in members {
            if (member["family_id"] != family_id): continue;
            family_member = spawn here +[member]+> node::person(
                id = member["uid"],
                family_id = member["family_id"],
                name = member["name"],
                date_of_birth = member["date_of_birth"],
                profession = member["profession"],
                gender = member["gender"],
                deceased = member["deceased"],
                parents = member["parents"],
                children = member["children"],
                spouse = member["spouse"] 
            );
            family_members.list::append(family_member);  
            
        }
        
    }

    with exit {
        for member_1 in family_members {
            for member_2 in family_members {
                if (member_1.id == member_2.id): continue;
                if (member_1.spouse == member_2.id and member_2.spouse == member_1.id) {
                    member_1 +[married]+> member_2;
                }
                if (member_1.id in member_2.children): member_1 +[child]+> member_2;
            }
        }
    }
}
walker age_categorization {
    // categorize the people according to the age

    has anchor categories = [];

    root: take-->node::family_root;
    family_root: take-->node::person;
    person {
        if (!here.deceased) {
            here::get_categorize;
            here::get_age;
            categories.l::append([here.category, here.age, here.name]);
        }
    }
    with exit {
        
        std.out( categories);
        report  categories;
    }
}
