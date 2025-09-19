package controller;

import dao.PostDAO;
import dao.UserDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.Post;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.UUID;

@WebServlet("/updatePost")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1MB
    maxFileSize = 1024 * 1024 * 5,   // 5MB
    maxRequestSize = 1024 * 1024 * 10 // 10MB
)
public class PostUpdateServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	private static final String UPLOAD_DIR = "uploads";
	
    private PostDAO postDAO;

    @Override
    public void init() throws ServletException {
        postDAO = new PostDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("userEmail");

        if (email == null) {
            response.sendRedirect("/jsp_project/views/login.jsp");
            return;
        }
        
        // 업로드 디렉토리 생성
        String applicationPath = request.getServletContext().getRealPath("");
        String uploadPath = applicationPath + File.separator + UPLOAD_DIR;
        
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        try {
            int postId = Integer.parseInt(request.getParameter("postId"));
            String title = request.getParameter("title");
            String storeName = request.getParameter("storeName");
            String location = request.getParameter("location");
            String foodType = request.getParameter("foodType");
            String content = request.getParameter("content");
            String keepImage = request.getParameter("keepImage");
            
            double x = 0.0;
            double y = 0.0;
            
            try {
                x = Double.parseDouble(request.getParameter("x"));
                y = Double.parseDouble(request.getParameter("y"));
            } catch (NumberFormatException e) {
                // 좌표가 없을 경우 무시
            }
            
            // 기존 게시물 정보 가져오기
            Post existingPost = postDAO.getPostById(postId);
            
            // 권한 확인
            UserDAO userDAO = new UserDAO();
            int userId = userDAO.getUserIdByEmail(email);
            
            if (existingPost.getUserId() != userId) {
                response.sendRedirect("/jsp_project/board?error=unauthorized");
                return;
            }
            
            // 이미지 파일 처리
            String imagePath = existingPost.getImagePath(); // 기본적으로 기존 이미지 경로 유지
            
            Part filePart = request.getPart("image");
            
            if (filePart != null && filePart.getSize() > 0) {
                // 새 이미지가 업로드된 경우
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                
                // 파일 확장자 검증
                String fileExt = fileName.substring(fileName.lastIndexOf(".")).toLowerCase();
                if (!fileExt.equals(".jpg") && !fileExt.equals(".jpeg") && 
                    !fileExt.equals(".png") && !fileExt.equals(".gif")) {
                    request.setAttribute("error", "지원하지 않는 이미지 형식입니다. JPG, PNG, GIF만 업로드 가능합니다.");
                    request.getRequestDispatcher("/editPost?postId=" + postId).forward(request, response);
                    return;
                }
                
                // 고유한 파일명 생성
                String uniqueFileName = UUID.randomUUID().toString() + fileExt;
                String filePath = uploadPath + File.separator + uniqueFileName;
                
                // 파일 저장
                filePart.write(filePath);
                
                // 데이터베이스에 저장할 상대 경로
                imagePath = UPLOAD_DIR + "/" + uniqueFileName;
                
                // 기존 이미지 파일 삭제
                if (existingPost.getImagePath() != null && !existingPost.getImagePath().isEmpty()) {
                    File oldFile = new File(applicationPath + File.separator + existingPost.getImagePath());
                    if (oldFile.exists()) {
                        oldFile.delete();
                    }
                }
                
                System.out.println("새 이미지 업로드 성공: " + imagePath);
            } else if ("false".equals(keepImage)) {
                // 이미지 제거 요청인 경우
                if (existingPost.getImagePath() != null && !existingPost.getImagePath().isEmpty()) {
                    File oldFile = new File(applicationPath + File.separator + existingPost.getImagePath());
                    if (oldFile.exists()) {
                        oldFile.delete();
                    }
                }
                imagePath = null; // 이미지 경로 제거
                System.out.println("이미지 제거됨");
            }

            Post post = new Post();
            post.setPostId(postId);
            post.setUserId(userId);
            post.setTitle(title);
            post.setStoreName(storeName);
            post.setLocation(location);
            post.setFoodType(foodType);
            post.setContent(content);
            post.setX(x);
            post.setY(y);
            post.setImagePath(imagePath);

            boolean updated = postDAO.updatePost(post);

            if (updated) {
                response.sendRedirect("/jsp_project/postDetail?postId=" + postId);
            } else {
                response.sendRedirect("/jsp_project/edit.jsp?postId=" + postId + "&error=true");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("/jsp_project/board");
        }
    }
}
