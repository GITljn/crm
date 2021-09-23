package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.utils.SqlSessionUtil;
import com.bjpowernode.crm.vo.PaginationVo;
import com.bjpowernode.crm.workbench.dao.ActivityDao;
import com.bjpowernode.crm.workbench.dao.ActivityRemarkDao;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.ActivityRemark;
import com.bjpowernode.crm.workbench.service.ActivityService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ActivityServiceImpl implements ActivityService {
    private ActivityDao activityDao = SqlSessionUtil.getSqlSession().getMapper(ActivityDao.class);
    private ActivityRemarkDao activityRemarkDao = SqlSessionUtil.getSqlSession().getMapper(ActivityRemarkDao.class);

    public Boolean save(Activity activity) {
        int count = activityDao.save(activity);
        Boolean flag = false;
        if (1 == count) {
            flag = true;
        }
        return flag;
    }

    public PaginationVo<Activity> pageList(Map<String, Object> map) {
        List<Activity> activities = activityDao.pageList(map);
        int total = activityDao.total(map);
//        System.out.println("=============="+total);
        PaginationVo<Activity> vo = new PaginationVo<Activity>();
        vo.setTotal(total);
        vo.setDataList(activities);
        return vo;
    }

    public boolean delete(String[] ids) {
        int count1 = activityRemarkDao.countDeleteNum(ids);
        int count2 = activityRemarkDao.delete(ids);
        int count3 = activityDao.delete(ids);
        if (count1 == count2 && count3 > 0) {
            return true;
        } else {
            return false;
        }
    }

    public Activity getActivity(String id) {
        Activity activity = activityDao.getActivity(id);
        return activity;
    }

    public boolean update(Activity activity) {
        boolean flag = false;
        int count = activityDao.update(activity);
        if (1 == count) {
            flag = true;
        }
        return flag;
    }

    public Activity detail(String id) {
        Activity activity = activityDao.detail(id);
        return activity;
    }

    public List<ActivityRemark> getRemarkList(String id) {
        return activityRemarkDao.getRemarkList(id);
    }

    public boolean deleteRemark(String id) {
        boolean flag = false;
        int count = activityRemarkDao.deleteRemark(id);
        if (1 == count) {
            flag = true;
        }
        return flag;
    }

    public Map<String, Object> saveRemark(ActivityRemark activityRemark) {
        boolean flag = false;
        int count = activityRemarkDao.saveRemark(activityRemark);
        if (1 == count) {
            flag = true;
        }
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("success", flag);
        map.put("activityRemark", activityRemark);
        return map;
    }

    public Map<String, Object> updateRemark(ActivityRemark activityRemark) {
        Map<String, Object> map = new HashMap<String, Object>();
        boolean flag = activityRemarkDao.updateRemark(activityRemark);
        map.put("success", flag);
        map.put("activityRemark", activityRemark);
        return map;
    }

    public List<Activity> showActivityList(String id) {
        return activityDao.showActivityList(id);
    }

    public List<Activity> searchActivityList(String clueId, String name) {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("clueId", clueId);
        map.put("name", name);
        return activityDao.searchActivityList(map);
    }

    public List<Activity> searchActivityListConvert(String name) {
        return activityDao.searchActivityListConvert(name);
    }
}
