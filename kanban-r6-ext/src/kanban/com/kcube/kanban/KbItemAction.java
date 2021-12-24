package com.kcube.kanban;

import com.kcube.lib.action.Action;
import com.kcube.lib.action.ActionContext;
import com.kcube.lib.jdbc.DbStorage;
import com.kcube.lib.json.JsonMapping;

public abstract class KbItemAction implements Action
{
	public static DbStorage _storage = new DbStorage(KbItem.class);
	public static DbStorage _cardStorage = new DbStorage(KbItemCard.class);
	public static DbStorage _backupstorage = new DbStorage(KbItemBackup.class);

	public static JsonMapping _factory = new JsonMapping(KbItem.class, "read");
	public static JsonMapping _cardFactory = new JsonMapping(KbItemCard.class, "read");
	public static JsonMapping _backupFactory = new JsonMapping(KbItemBackup.class, "read");
	public static JsonMapping _cardAttachmentFactory = new JsonMapping(KbItemCard.class, "attachment");

	/**
	 * ActionContext에서 Item 객체를 추출한다.
	 */
	protected KbItem unmarshal(ActionContext ctx) throws Exception
	{
		KbItem client = (KbItem) _factory.unmarshal(ctx.getParameter("item"));
		return client;
	}

	/**
	 * ActionContext에서 Item 객체를 추출한다.
	 */
	protected KbItemCard unmarshalCard(ActionContext ctx) throws Exception
	{
		KbItemCard client = (KbItemCard) _cardFactory.unmarshal(ctx.getParameter("item"));
		return client;
	}

	/**
	 * ActionContext에서 Item 객체를 추출한다.
	 */
	protected KbItemBackup unmarshalBackup(ActionContext ctx) throws Exception
	{
		KbItemBackup client = (KbItemBackup) _backupFactory.unmarshal(ctx.getParameter("item"));
		return client;
	}
}
