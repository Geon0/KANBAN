package com.kcube.kanban;

import com.kcube.sys.usr.PermissionDeniedException;
import com.kcube.sys.usr.UserPermission;

public class KbItemCardPermission
{
	/**
	 * 등록자 / 작성자 인지 확인한다.
	 */
	public static void checkOwner(KbItemCard.Opinion opn) throws Exception
	{
		if (!isRgstUser(opn))
		{
			throw new PermissionDeniedException();
		}
	}

	/**
	 * 의견 등록 여부을 확인한다.
	 */
	public static boolean isRgstUser(KbItemCard.Opinion opn)
	{
		return (opn.isCurrentOwner() || UserPermission.isAdmin());
	}
}
