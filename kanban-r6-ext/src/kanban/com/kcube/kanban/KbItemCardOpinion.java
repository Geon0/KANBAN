package com.kcube.kanban;

import java.util.Date;

import com.kcube.doc.opn.OpinionManager;
import com.kcube.doc.opn.OpinionReply;
import com.kcube.lib.action.ActionContext;
import com.kcube.lib.jdbc.DbService;
import com.kcube.lib.jdbc.DbStorage;
import com.kcube.lib.json.JsonMapping;
import com.kcube.lib.json.JsonWriter;
import com.kcube.sys.usr.UserService;

public class KbItemCardOpinion
{
	static OpinionManager _opinion = new OpinionManager(KbItemCard.class, KbItemCard.Opinion.class, "cardid");
	static OpinionReply _opinionReply = new OpinionReply(KbItemCard.Opinion.class);

	static JsonMapping _opn = new JsonMapping(KbItemCard.Opinion.class);
	static DbStorage _opnStorage = new DbStorage(KbItemCard.Opinion.class);

	/**
	 * 의견을 등록한다.
	 * <p>
	 * 익명 기능 포함
	 */
	public static class AddOpinion extends KbItemAction
	{
		public void execute(ActionContext ctx) throws Exception
		{
			KbItemCard.Opinion client = (KbItemCard.Opinion) _opn.unmarshal(ctx.getParameter("opn"));

			KbItemCard.Opinion opinion = new KbItemCard.Opinion();
			opinion.setGid(client.getGid());
			opinion.setContent(client.getContent());
			opinion.setItemId(client.getItemId());
			opinion.setOpnCode(KbItemCard.Opinion.USER);
			opinion.setAlimiMentionUsers(client.getAlimiMentionUsers());
			if (client.getRgstUser() == null)
			{
				opinion.setRgstUser(UserService.getUser());
			}
			else
			{
				opinion.setRgstUser(client.getRgstUser());
			}
			opinion.setRgstUserId(UserService.getUserId());
			opinion.setRgstDate(new Date());

			_opinion.addOpinion(opinion.getItemId(), opinion);
			_opn.marshal(ctx.getWriter(), opinion);
		}
	}

	/**
	 * 의견을 수정한다.
	 */
	public static class UpdateOpinion extends KbItemAction
	{
		public void execute(ActionContext ctx) throws Exception
		{
			Long id = ctx.getLong("id");
			Long vrtl = ctx.getLong("vrtl", null);
			String name = ctx.getParameter("name");
			String content = ctx.getParameter("content");
			KbItemCard.Opinion opn = (KbItemCard.Opinion) DbService.load(KbItemCard.Opinion.class, id);
			KbItemCardPermission.checkOwner(opn);
			_opinion.updateOpinion(opn, vrtl, name, content);
			_opinion.writeUpdate(new JsonWriter(ctx.getWriter()), opn);
		}
	}

	/**
	 * 의견을 삭제한다.
	 */
	public static class DeleteOpinion extends KbItemAction
	{
		public void execute(ActionContext ctx) throws Exception
		{
			Long id = ctx.getLong("id");
			KbItemCard.Opinion opn = (KbItemCard.Opinion) DbService.load(KbItemCard.Opinion.class, id);
			KbItemCardPermission.checkOwner(opn);
			_opinionReply.checkReply(opn);
			_opinion.deleteOpinion(id);
		}
	}
}
