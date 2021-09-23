package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActivityRemarkDao {

    int delete(String[] ids);

    int countDeleteNum(String[] ids);

    int deleteRemark(String id);

    int saveRemark(ActivityRemark activityRemark);

    List<ActivityRemark> getRemarkList(String id);

    boolean updateRemark(ActivityRemark activityRemark);
}
