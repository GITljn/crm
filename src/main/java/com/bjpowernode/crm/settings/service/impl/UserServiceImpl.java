package com.bjpowernode.crm.settings.service.impl;

import com.bjpowernode.crm.exception.LoginException;
import com.bjpowernode.crm.settings.dao.UserDao;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.SqlSessionUtil;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class UserServiceImpl implements UserService {
    private UserDao userDao = SqlSessionUtil.getSqlSession().getMapper(UserDao.class);

    public User login(String loginAct, String loginPwd, String ip) throws LoginException {
        Map<String, String> map = new HashMap<String, String>();
        map.put("loginAct", loginAct);
        map.put("loginPwd", loginPwd);
        map.put("ip", ip);
        User user = userDao.login(map);
        if (user == null) {
            throw new LoginException("账号或密码错误");
        }
        String expireTime = user.getExpireTime();
        String currentTime = DateTimeUtil.getSysTime();
        if (currentTime.compareTo(expireTime) > 0) {
            throw new LoginException("账号已过期");
        }
        if ("0".equals(user.getLockState())) {
            throw new LoginException("账号已锁定");
        }
        String allowIps = user.getAllowIps();
        if (allowIps != null && allowIps != "") {
            if (!allowIps.contains(ip)) {
                throw new LoginException("ip地址受限");
            }
        }


        return user;
    }

    public List<User> getUserList() {
        return userDao.getUserList();
    }
}
