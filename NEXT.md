
1. unique constraint built in does not work
- it throws with pragma error
- try use only some fields 
- or try custom add constraint 
-- https://www.tutorialsteacher.com/postgresql/add-constraint 
-- https://neon.tech/postgresql/postgresql-tutorial/postgresql-unique-constraint

2. also, i cannot just insert. i should insert with on conflict update, or do nothing really