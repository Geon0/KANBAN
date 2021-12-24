package com.kcube.kanban;

import java.util.Date;
import java.util.Iterator;
import java.util.Set;
import java.util.TreeSet;

import org.hibernate.Query;

import com.kcube.doc.file.AttachmentManager;
import com.kcube.lib.jdbc.DbService;
import com.kcube.sys.upload.Upload;
import com.kcube.sys.usr.UserService;

public class KbAttachmentManager extends AttachmentManager
{

	/**
	 * 카드의 최신버전 리스트를 반환한다.
	 * @param id
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public static Set<? extends KbItemCard.CardAttachment> getLastVersionAttByItemId(Long id) throws Exception
	{
		Query query = DbService.getSession().getNamedQuery("getKbLastVersionFileByItemId");
		query.setLong("itemId", id);
		Iterator<KbItemCard.CardAttachment> i = query.iterate();
		Set<KbItemCard.CardAttachment> set = new TreeSet<KbItemCard.CardAttachment>();
		while (i.hasNext())
		{
			set.add(i.next());
		}
		return set;
	}

	/**
	 * 파일업데이트
	 * @param client
	 * @param server
	 */
	public static void fileUpdate(KbItemCard.CardAttachment client, KbItemCard.CardAttachment server)
	{
		server.setFilename(client.getFilename());
		server.setFilesize(client.getFilesize());
		server.setRgstUser(client.getRgstUser());
		server.setInstDate(client.getInstDate());
		server.setType(client.getType());

		server.setDnldCnt(client.getDnldCnt());
		server.setPath(client.getPath());
		server.setGid(client.getGid());
		server.setMethod(client.getMethod());
		server.setVrsnNum(client.getVrsnNum());
		server.setLastVersion(false);
	}

	/**
	 * 파일을 버전업하며 업데이트
	 * @param client 업데이트 기준
	 * @param server 업데이트 대상
	 * @throws Exception
	 * @throws NumberFormatException
	 */
	public static void fileVersionUpUpdate(KbItemCard.CardAttachment client, KbItemCard.CardAttachment server)
		throws Exception
	{
		server.setRgstUser(UserService.getUser());
		server.setInstDate(new Date());
		server.setDnldCnt(client.getDnldCnt());

		/**
		 * 기존 객체가 가지고 있던 버전+1 한다.
		 */
		server.setVrsnNum(server.getVrsnNum() + 1);
		server.setLastVersion(true);

		Upload upload = (Upload) DbService.load(Upload.class, new Long(client.getPath()));
		server.setFilename(upload.getFilename());
		server.setFilesize(upload.getFilesize());
		server.setPath(upload.getPath());
		server.setMethod(upload.getMethod());
		DbService.remove(upload);
	}

}
