package com.kcube.kanban;

import java.sql.ResultSet;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.kcube.doc.Item;
import com.kcube.doc.ItemPermission;
import com.kcube.kanban.KbItemCard.CardAttachment;
import com.kcube.lib.action.ActionContext;
import com.kcube.lib.jdbc.DbService;
import com.kcube.lib.json.JsonWriter;
import com.kcube.lib.sql.SqlSelect;
import com.kcube.lib.sql.SqlUpdate;
import com.kcube.sys.module.ModuleParam;
import com.kcube.sys.usr.UserService;

public class KbItemCardUser
{
	private static KbAttachmentManager _cardAttachment = new KbAttachmentManager();

	/**
	 * 카드를 조회한다.
	 */
	public static class ReadByUser extends KbItemAction
	{
		public void execute(ActionContext ctx) throws Exception
		{
			KbItemCard server = (KbItemCard) _cardStorage.load(ctx.getLong("id"));
			ItemPermission.checkOwner(server);
			_cardFactory.marshal(ctx.getWriter(), server);
		}
	}

	/**
	 * 카드를 조회한다.
	 */
	public static class ReadCategoryByUser extends KbItemAction
	{
		public void execute(ActionContext ctx) throws Exception
		{
			KbItem server = (KbItem) _storage.load(ctx.getLong("id"));
			ItemPermission.checkOwner(server);
			_factory.marshal(ctx.getWriter(), server);
		}
	}

	/**
	 * 기본 카드를 생성한다.
	 */
	public static class DoRegister extends KbItemAction
	{
		public void execute(ActionContext ctx) throws Exception
		{
			KbItemCard client = unmarshalCard(ctx);
			KbItemCard server = new KbItemCard();

			server.setTitle(client.getTitle());
			server.setItemId(client.getItemId());
			server.setRowPoint(client.getRowPoint());
			server.setRowTitle(client.getRowTitle());
			server.setColumnPoint(client.getColumnPoint());
			server.setColumnTitle(client.getColumnTitle());
			server.setRgstUser(UserService.getUser());
			server.setColor("b2b7bd");
			server.setSort(client.getSort());
			server.setVisible(true);
			server.setLastUpdt(new Date());
			server.setStatus(Item.REGISTERED_STATUS);
			DbService.save(server);

			_cardFactory.marshal(ctx.getWriter(), server);
		}
	}

	/**
	 * 카드의 제목을 변경한다.
	 */
	public static class CardTitleUpdate extends KbItemAction
	{
		public void execute(ActionContext ctx) throws Exception
		{
			KbItemCard client = unmarshalCard(ctx);
			KbItemCard server = (KbItemCard) _cardStorage.load(client.getId());
			ItemPermission.checkOwner(server);
			ItemPermission.delete(server);
			server.setTitle(client.getTitle());
			server.setLastUpdt(new Date());
		}
	}

	/**
	 * 카드를 삭제한다.
	 */
	public static class CardDelete extends KbItemAction
	{
		public void execute(ActionContext ctx) throws Exception
		{
			Long id = ctx.getLong("id");
			KbItemCard server = (KbItemCard) _cardStorage.loadWithLock(id);
			ItemPermission.checkOwner(server);
			ItemPermission.delete(server);
			server.setStatus(KbItemCard.DELETED_STATUS);
			server.updateVisible(false);
			server.setLastUpdt(new Date());
		}
	}

	/**
	 * 카드의 색상을 변경한다.
	 */
	public static class CardColorUpdate extends KbItemAction
	{
		public void execute(ActionContext ctx) throws Exception
		{
			KbItemCard client = unmarshalCard(ctx);
			KbItemCard server = (KbItemCard) _cardStorage.load(client.getId());
			ItemPermission.checkOwner(server);
			ItemPermission.delete(server);
			server.setColor(client.getColor());
			server.setLastUpdt(new Date());
		}
	}

	/**
	 * 카드 내용을 변경한다.
	 */
	public static class CardContentUpdate extends KbItemAction
	{
		public void execute(ActionContext ctx) throws Exception
		{
			KbItemCard client = unmarshalCard(ctx);
			KbItemCard server = (KbItemCard) _cardStorage.load(client.getId());
			ItemPermission.checkOwner(server);
			ItemPermission.delete(server);
			server.setContent(client.getContent());
			server.setLastUpdt(new Date());
		}
	}

	/**
	 * 파일을 다운로드 한다.
	 */
	public static class DownloadByUser extends KbItemAction
	{
		public void execute(ActionContext ctx) throws Exception
		{
			KbItemCard.CardAttachment att = (KbItemCard.CardAttachment) DbService.load(
				KbItemCard.CardAttachment.class,
				ctx.getLong("id"));
			KbItemCard server = (KbItemCard) att.getItem();
			ItemPermission.checkOwner(server);
			ctx.store(att);
		}
	}

	/**
	 * 카드의 파일을 등록한다.
	 */
	public static class DoFileRegister extends KbItemAction
	{
		public void execute(ActionContext ctx) throws Exception
		{
			KbItemCard client = (KbItemCard) _cardAttachmentFactory.unmarshal(ctx.getParameter("item"));
			KbItemCard server = (KbItemCard) DbService.loadWithLock(KbItemCard.class, client.getId());
			ItemPermission.delete(server);
			for (KbItemCard.CardAttachment att : client.getCardAttachments())
			{
				att.setRgstUser(UserService.getUser());
				att.setItem(server);
				att.setInstDate(new Date());
				att.setLastVersion(true);
				_cardAttachment.update(att);
				server.setFileCnt(server.getFileCnt() + 1);
				DbService.commit();
			}
			KbItemCard fake = new KbItemCard();
			fake.setCardAttachments(KbAttachmentManager.getLastVersionAttByItemId(server.getId()));

			_cardFactory.marshal(ctx.getWriter(), fake);
		}
	}

	/**
	 * 파일을 삭제한다.
	 */
	public static class RemoveFile extends KbItemAction
	{
		public void execute(ActionContext ctx) throws Exception
		{
			ResultSet rs = getFileGid(ctx.getLong("id"));
			KbItemCard.CardAttachment att;
			KbItemCard item = null;
			while (rs.next())
			{
				att = (KbItemCard.CardAttachment) DbService.load(KbItemCard.CardAttachment.class, rs.getLong("fileid"));
				item = (KbItemCard) att.getItem();
				item.setLastUpdt(new Date());
				_cardAttachment.deleteXA(att);
				DbService.remove(att);

				if (att.isLastVersion())
				{
					item.setFileCnt(item.getFileCnt() - 1);
				}
			}
			KbItemCard fake = new KbItemCard();
			fake.setCardAttachments(KbAttachmentManager.getLastVersionAttByItemId(item.getId()));

			_cardFactory.marshal(ctx.getWriter(), fake);
		}

		private ResultSet getFileGid(Long gid) throws Exception
		{
			SqlSelect stmt = new SqlSelect();
			stmt.select("fileid");
			stmt.from("kb_item_card_file");
			stmt.where("gid = ? ", gid);
			return stmt.query();
		}
	}

	/**
	 * 카드를 폐기한다.
	 */
	public static class DoRemove extends KbItemAction
	{
		public void execute(ActionContext ctx) throws Exception
		{
			Long id = ctx.getLong("id");
			KbItemCard server = (KbItemCard) _cardStorage.loadWithLock(id);
			ItemPermission.checkOwner(server);
			ItemPermission.remove(server);
			_cardAttachment.remove(server.getCardAttachments());
			DbService.remove(server);
		}
	}

	/**
	 * 카드를 복원한다.
	 */
	public static class DoRecovery extends KbItemAction
	{
		public void execute(ActionContext ctx) throws Exception
		{
			KbItemCard client = unmarshalCard(ctx);
			KbItemCard server = (KbItemCard) _cardStorage.loadWithLock(client.getId());
			ItemPermission.recover(server);
			ItemPermission.checkOwner(server);
			server.setRowPoint(client.getRowPoint());
			server.setRowTitle(client.getRowTitle());
			server.setStatus(KbItemCard.REGISTERED_STATUS);
			server.updateVisible(true);
			server.setLastUpdt(new Date());
			server.setSort(getMaxSort(server));
		}

		/**
		 * 카드의 정렬 값을 MAX값으로 세팅한다.
		 * @param server
		 * @return
		 * @throws Exception
		 */
		private Long getMaxSort(KbItemCard server) throws Exception
		{
			SqlSelect stmt = new SqlSelect();
			stmt.select("max(sort)+1 sort");
			stmt.from("kb_item_card");
			stmt.where("itemid = ? ", server.getItemId());
			stmt.where("row_point = ? ", server.getRowPoint());
			stmt.where("column_point = ? ", server.getColumnPoint());
			stmt.where("status = ? ", KbItemCard.REGISTERED_STATUS);
			stmt.where("isvisb = ? ", true);
			ResultSet rs = stmt.query();
			rs.next();

			return rs.getLong("sort");
		}
	}

	/**
	 * 카드 목록을 호출한다.
	 * @author Geon-0
	 */
	public static class CardListByUser extends KbItemAction
	{

		public void execute(ActionContext ctx) throws Exception
		{
			Long id = ctx.getLong("id");
			boolean visb = false;
			boolean backup = false;
			boolean delete = false;
			String _del = ctx.getParameter("isDel");

			if (_del != null && _del.equals("N"))
				visb = true;

			if (_del != null && _del.equals("B"))
				backup = true;

			if (_del != null && _del.equals("Y"))
				delete = true;

			KbItem item = (KbItem) _storage.load(id);
			ItemPermission.checkOwner(item);

			SqlSelect stmt = getCardList(id, visb, backup, delete);
			ResultSet rs = stmt.query();

			JsonWriter writer = new JsonWriter(ctx.getWriter());
			writer.writeListHeader(stmt.count());

			while (rs.next())
			{
				writer.startList();
				writer.setFirstAttr(true);
				writer.setAttribute("id", rs.getLong("cardid"));
				writer.setAttribute("title", rs.getString("title"));
				writer.setAttribute("content", rs.getString("content"));
				writer.setAttribute("color", rs.getString("color"));
				writer.setAttribute("status", rs.getInt("status"));
				writer.setAttribute("startDate", rs.getTimestamp("strt_date"));
				writer.setAttribute("endDate", rs.getTimestamp("end_date"));
				writer.setAttribute("fileCnt", rs.getLong("file_cnt"));
				writer.setAttribute("opnCnt", rs.getLong("opn_cnt"));
				writer.setAttribute("rowPoint", rs.getString("row_point"));
				writer.setAttribute("columnPoint", rs.getString("column_point"));
				writer.setAttribute("sort", rs.getLong("sort"));
				writer.endList();
			}
			writer.writeListFooter();
		}

		private SqlSelect getCardList(Long id, boolean visb, boolean backup, boolean delete)
		{
			SqlSelect stmt = new SqlSelect();
			stmt.select(
				"cardid, title, content, color, rgst_userid, rgst_name, rgst_disp, status, strt_date, end_date, file_ext, file_cnt, opn_cnt, row_point, column_point, sort");
			stmt.from("kb_item_card ");
			stmt.where("itemid = ? ", id);
			stmt.where("isvisb = ? ", visb);

			if (backup == true)
			{
				stmt.where("status = ? ", KbItemCard.BACKUP_STATUS);
			}

			if (delete == true)
			{
				stmt.where("status =? ", KbItemCard.DELETED_STATUS);
			}

			return stmt;
		}
	}

	/**
	 * 카테고리 삭제 처리를 한다. layout 저장은 KbItemOwner.SaveLayoutByOwner 에서 하며. 해당 영역의 카드들의 삭제 처리 및
	 * 해당 카드들의 카테고리 정보 업데이트 작업만 수행한다.
	 */
	public static class DelLayoutByUser extends KbItemAction
	{
		public void execute(ActionContext ctx) throws Exception
		{
			String uuid = ctx.getParameter("uuid");
			updateRowForDelCards(uuid);

			SqlSelect stmt = getDeleteCardList(uuid);
			ResultSet rs = stmt.query();
			while (rs.next())
			{
				KbItemCard server = (KbItemCard) _cardStorage.loadWithLock(rs.getLong("cardid"));
				server.setStatus(KbItemCard.DELETED_STATUS);
				server.updateVisible(false);
				server.setLastUpdt(new Date());
				server.setRowPoint(KbItemCard.del_row_point);
				server.setRowTitle(KbItemCard.del_row_title);
			}

		}

		private SqlSelect getDeleteCardList(String uuid)
		{
			SqlSelect stmt = new SqlSelect();
			stmt.select("cardid");
			stmt.from("kb_item_card");
			stmt.where("status != ?", KbItemCard.DELETED_STATUS);
			stmt.where("isvisb = ?", true);
			stmt.where("row_point = ? ", uuid);
			return stmt;
		}

		/*
		 * 이미 삭제 처리된 카드들은 row_point 와 row_title 만 변경처리한다.
		 */
		private void updateRowForDelCards(String uuid) throws Exception
		{
			SqlUpdate update = new SqlUpdate("kb_item_card");
			update.setString("row_point", KbItemCard.del_row_point);
			update.setString("row_title", KbItemCard.del_row_title);
			update.where("row_point = ?", uuid);
			update.where("status = ?", KbItemCard.DELETED_STATUS);
			update.where("isvisb = ?", false);
			update.execute();
		}
	}

	/**
	 * 드래그 후 카드의 카테고리 정보를 업데이트 한다.
	 */
	public static class SaveDragCardsByUser extends KbItemAction
	{
		public void execute(ActionContext ctx) throws Exception
		{
			String values = ctx.getParameter("cards");
			ObjectMapper mapper = new ObjectMapper();
			List<Map> list = mapper.readValue(values, new TypeReference<List<Map>>()
			{
			});
			for (Map m : list)
			{
				Integer cardid = (Integer) m.get("cardid");
				Integer sort = (Integer) m.get("sort");
				String rowPoint = (String) m.get("rowPoint");
				String rowTitle = (String) m.get("rowTitle");
				String columnPoint = (String) m.get("columnPoint");
				String columnTitle = (String) m.get("columnTitle");

				KbItemCard server = (KbItemCard) _cardStorage.loadWithLock(new Long(cardid));
				server.setSort(new Long(sort));
				server.setRowPoint(rowPoint);
				server.setRowTitle(rowTitle);
				server.setColumnPoint(columnPoint);
				server.setColumnTitle(columnTitle);
				DbService.save(server);
			}
		}
	}

	/**
	 * 카드의 시작일, 종료일을 수정한다.
	 */
	public static class CardDateUpdate extends KbItemAction
	{
		public void execute(ActionContext ctx) throws Exception
		{
			KbItemCard client = unmarshalCard(ctx);
			KbItemCard server = (KbItemCard) _cardStorage.load(client.getId());
			ItemPermission.checkOwner(server);

			server.setStartDate(client.getStartDate());
			server.setEndDate(client.getEndDate());
			server.setLastUpdt(new Date());
		}
	}

	/**
	 * 카드의 파일을 수정한다.
	 */
	public static class DoFileUpdate extends KbItemAction
	{
		public void execute(ActionContext ctx) throws Exception
		{
			String method = ctx.getParameter("method");
			KbItemCard client = (KbItemCard) _cardAttachmentFactory.unmarshal(ctx.getParameter("item"));
			KbItemCard server = (KbItemCard) DbService.loadWithLock(KbItemCard.class, client.getId());
			ItemPermission.checkOwner(server);
			server.setLastUpdt(new Date());
			for (CardAttachment att : client.getCardAttachments())
			{
				KbItemCard.CardAttachment serverAtt = (CardAttachment) DbService.load(
					KbItemCard.CardAttachment.class,
					att.getId());
				if (method.equals("edit"))
				{
					att.setVrsnNum(serverAtt.getVrsnNum());
					if (serverAtt.getVrsnNum() != 1)
					{
						att.setGid(serverAtt.getGid());
					}
					att.setRgstUser(UserService.getUser());
					att.setItem(server);
					att.setInstDate(new Date());
					att.setLastVersion(true);
					_cardAttachment.update(att);
					DbService.remove(serverAtt);
					DbService.commit();
				}
				else if (method.equals("vrsn"))
				{
					CardAttachment oldAtt = new CardAttachment();
					KbAttachmentManager.fileUpdate(serverAtt, oldAtt);
					KbAttachmentManager.fileVersionUpUpdate(att, serverAtt);
					oldAtt.setItem(server);
					DbService.save(oldAtt);
				}
			}
			KbItemCard fake = new KbItemCard();
			fake.setCardAttachments(KbAttachmentManager.getLastVersionAttByItemId(server.getId()));
			_cardFactory.marshal(ctx.getWriter(), fake);
		}
	}

	public static class restoreLayoutByUser extends KbItemAction
	{
		public void execute(ActionContext ctx) throws Exception
		{
			ModuleParam mp = ctx.getModuleParam();
			JSONParser parser = new JSONParser();
			String restoreUuid = ctx.getParameter("uuid");
			String restoreTitle = ctx.getParameter("title");

			KbItemSql sql = new KbItemSql(mp);

			SqlSelect master = sql.getItemid();
			ResultSet result = master.query();
			if (result.next())
			{
				Long id = result.getLong("itemid");
				KbItem server = (KbItem) _storage.loadWithLock(id);

				Object obj = parser.parse(server.getContent());
				JSONArray ctOrgin = (JSONArray) obj;
				String json = "{\"uuid\":\"" + restoreUuid + "\",\"title\":\"" + restoreTitle + "\"}";
				Object objj = parser.parse(json);
				JSONObject ctRestore = (JSONObject) objj;
				ctOrgin.add(ctRestore);
				server.setContent(ctOrgin.toJSONString());
				SqlSelect stmt = sql.restoreCard(id, ctRestore.get("uuid").toString());
				ResultSet rs = stmt.query();
				while (rs.next())
				{
					Long cardid = rs.getLong("cardid");
					KbItemCard card = (KbItemCard) _cardStorage.loadWithLock(cardid);
					ItemPermission.checkOwner(card);
					card.setStatus(KbItemCard.REGISTERED_STATUS);
					card.setVisible(true);
					card.setLastUpdt(new Date());
				}

				SqlSelect restore = sql.getBackupItemid(ctRestore.toJSONString());
				ResultSet rsbackup = restore.query();
				if (rsbackup.next())
				{
					Long itemid = rsbackup.getLong("itemid");
					KbItemBackup backup = (KbItemBackup) _backupstorage.loadWithLock(itemid);
					DbService.remove(backup);
				}
			}

		}

	}

}
