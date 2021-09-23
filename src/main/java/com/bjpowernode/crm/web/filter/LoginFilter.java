package com.bjpowernode.crm.web.filter;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class LoginFilter implements Filter {
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;
        // 既可以得到前端路径也可以得到后端路径
        String path = request.getServletPath();
        if ("/login.jsp".equals(path) || "/settings/user/login.do".equals(path) || request.getSession(false) != null) {
            filterChain.doFilter(servletRequest, servletResponse);
        } else {
            // 如果为空，则跳转到登录页面
            // 使用请求转发的路径：/login.jsp
            // request.getRequestDispatcher("/login.jsp").forward(request, response);
            // 使用重定向的路径：/网站名/login.jsp
            // 不使用请求转发，因为地址栏不会发生变化，如果想刷新当前页则会跳到之前页面
            // response.sendRedirect("/crm/login.jsp");
             response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }
}
