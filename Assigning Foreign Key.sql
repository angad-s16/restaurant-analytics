select count(*)
from menu_items;

select count(*)
from order_details;

ALTER TABLE order_details 
ADD CONSTRAINT fk_item FOREIGN KEY (item_id) 
REFERENCES menu_items(menu_item_id);

