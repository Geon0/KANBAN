ALTER TABLE KB_ITEM ADD(
	CONSTRAINT XPK_KB_ITEM PRIMARY KEY (ITEMID));
	
ALTER TABLE KB_ITEM_CARD ADD(
	CONSTRAINT XPK_KB_ITEM_CARD PRIMARY KEY (CARDID));
	
ALTER TABLE KB_ITEM_CARD_FILE ADD(
	CONSTRAINT XPK_KB_ITEM_CARD_FILE PRIMARY KEY (FILEID));
	
ALTER TABLE KB_ITEM_CARD_OPN ADD(
	CONSTRAINT XPK_KB_ITEM_CARD_OPN PRIMARY KEY (OPNID));
	
ALTER TABLE KB_ITEM_BACKUP ADD(
	CONSTRAINT XPK_KB_ITEM_BACKUP PRIMARY KEY (ITEMID));