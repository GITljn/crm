package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.settings.dao.UserDao;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.utils.SqlSessionUtil;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.workbench.dao.ClueActivityRelationDao;
import com.bjpowernode.crm.workbench.dao.ClueDao;
import com.bjpowernode.crm.workbench.dao.ClueRemarkDao;
import com.bjpowernode.crm.workbench.domain.Clue;
import com.bjpowernode.crm.workbench.domain.ClueRemark;
import com.bjpowernode.crm.workbench.service.ClueService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ClueServiceImpl implements ClueService {
    private ClueDao clueDao = SqlSessionUtil.getSqlSession().getMapper(ClueDao.class);
    private UserDao userDao = SqlSessionUtil.getSqlSession().getMapper(UserDao.class);
    private ClueRemarkDao clueRemarkDao = SqlSessionUtil.getSqlSession().getMapper(ClueRemarkDao.class);
    private ClueActivityRelationDao clueActivityRelationDao = SqlSessionUtil.getSqlSession().getMapper(ClueActivityRelationDao.class);

    public boolean save(Clue clue) {
        boolean flag = false;
        int count = clueDao.save(clue);
        if (1 == count) {
            flag = true;
        }
        return flag;
    }

    public Map<String, Object> pageList(Map<String, Object> map) {
        Map<String, Object> webMap = new HashMap<String, Object>();
        int total = clueDao.total(map);
        List<Clue> clues = clueDao.pageList(map);
        webMap.put("total", total);
        webMap.put("clues", clues);
        return webMap;
    }

    public Map<String, Object> getUserListAndClue(String id) {
        Map<String, Object> map = new HashMap<String, Object>();
        List<User> users = userDao.getUserList();
        map.put("users", users);
        Clue clue = clueDao.getClueById(id);
        map.put("clue", clue);
        return map;
    }

    public boolean update(Clue clue) {
        boolean flag = false;
        int count = clueDao.update(clue);
        if (1 == count) {
            flag = true;
        }
        return flag;
    }

    public boolean delete(String[] ids) {
        boolean flag = false;
        int countClue = clueDao.delete(ids);
        clueRemarkDao.deleteRemarks(ids);
        if (ids.length == countClue) {
            flag = true;
        }
        return flag;
    }

    public Map<String, Object> getClueAndOwnerById(String id) {
        Map<String, Object> clue = clueDao.getClueAndOwnerById(id);
        return clue;
    }

    public List<ClueRemark> showRemarkList(String clueId) {
        List<ClueRemark> clueRemarks = clueRemarkDao.showRemarkList(clueId);
        return clueRemarks;
    }

    public Map<String, Object> saveRemark(ClueRemark clueRemark) {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("clueRemark", clueRemark);
        boolean flag = false;
        int count = clueRemarkDao.saveRemark(clueRemark);
        if (1 == count) {
            flag = true;
        }
        map.put("flag", flag);
        return map;
    }

    public boolean deleteRemark(String id) {
        boolean flag = false;
        int count = clueRemarkDao.deleteRemark(id);
        if (1 == count) {
            flag = true;
        }
        return flag;
    }

    public Map<String, Object> updateRemark(ClueRemark clueRemark) {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("clueRemark", clueRemark);
        boolean success = false;
        int count = clueRemarkDao.updateRemark(clueRemark);
        if (1 == count) {
            success = true;
        }
        map.put("success", success);
        return map;
    }

    public boolean unBind(String id) {
        boolean flag = false;
        int count = clueActivityRelationDao.unBind(id);
        if (1 == count) {
            flag = true;
        }
        return flag;
    }

    public boolean bind(String clueId, String[] ids) {
        boolean flag = true;
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("clueId", clueId);
        for (String id : ids) {
            map.put("activityId", id);
            map.put("id", UUIDUtil.getUUID());
            int count = clueActivityRelationDao.bind(map);
            if (1 != count) {
                flag = false;
            }
        }
        return flag;
    }
}
