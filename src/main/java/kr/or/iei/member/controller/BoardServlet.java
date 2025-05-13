package kr.or.iei.member.controller;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;



/**
 * Servlet implementation class BoardServlet
 */
@WebServlet("/board")
public class BoardServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public BoardServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	 String type = request.getParameter("type");  //받아서 스위치로
    String path = null;

    //각 게시판별 주소 입력하기. 일단 임시로 비워둠.
    switch(type) {
      case "notice":
        path = "#";
        break;
      case "free":
        path = "#";
        break;
      case "worry":
        path = "#";
        break;
      case "recommend":
        path = "#";
        break;
      case "best":
        path = "#";
        break;
      case "intro":
        path = "#";
        break;
      case "test":
        path = "#";
        break;
      case "1" :
        path = "#";
      case "2" :
        path = "#";
      case "3" :
        path = "#";
      case "4" :
        path = "#";
      default:
        path = "#"; // 없는 메뉴 예외 처리
    }

    RequestDispatcher view = request.getRequestDispatcher(path);
    view.forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
