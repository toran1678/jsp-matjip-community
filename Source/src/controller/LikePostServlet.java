package controller;

import dao.LikeDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/likePost")
public class LikePostServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// 세션에서 사용자 정보 확인
		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("userId") == null) {
			response.sendRedirect("views/login.jsp");
			return;
		}

		// 세션에서 userId는 Integer 타입으로 저장된 것으로 가정
		int userId = (Integer) session.getAttribute("userId");

		// 파라미터에서 postId 가져오기
		String postIdParam = request.getParameter("postId");
		if (postIdParam == null || !postIdParam.matches("\\d+")) {
			response.sendRedirect("board");
			return;
		}
		int postId = Integer.parseInt(postIdParam);

		// 좋아요 추가
		LikeDAO dao = new LikeDAO();
		dao.toggleLike(postId, userId);

		// 상세 페이지로 리다이렉트
		response.sendRedirect("postDetail?postId=" + postId);
	}
	
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException {
	    doPost(request, response); // GET 요청도 POST처럼 처리
	}
}