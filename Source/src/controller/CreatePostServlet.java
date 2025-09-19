package controller;

import dao.PostDAO;
import dao.UserDAO;
import model.Post;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.UUID;

@WebServlet("/createPost")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1MB
    maxFileSize = 1024 * 1024 * 5,   // 5MB
    maxRequestSize = 1024 * 1024 * 10 // 10MB
)
public class CreatePostServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // 이미지 저장 경로 설정
    private static final String UPLOAD_DIR = "uploads";
    
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

        String title = request.getParameter("title");
        String storeName = request.getParameter("storeName");
        String location = request.getParameter("location");
        String foodType = request.getParameter("foodType");
        String content = request.getParameter("content");        
        double x = 0.0;
        double y = 0.0;
        
        try {
            x = Double.parseDouble(request.getParameter("x"));
            y = Double.parseDouble(request.getParameter("y"));
        } catch (NumberFormatException e) {
            // 좌표가 없을 경우 무시
        }
        
        // 이미지 파일 처리
        String imagePath = null;
        Part filePart = request.getPart("image");
        
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            
            // 파일 확장자 검증
            String fileExt = fileName.substring(fileName.lastIndexOf(".")).toLowerCase();
            if (!fileExt.equals(".jpg") && !fileExt.equals(".jpeg") && 
                !fileExt.equals(".png") && !fileExt.equals(".gif")) {
                request.setAttribute("error", "지원하지 않는 이미지 형식입니다. JPG, PNG, GIF만 업로드 가능합니다.");
                request.getRequestDispatcher("/write.jsp").forward(request, response);
                return;
            }
            
            // 고유한 파일명 생성
            String uniqueFileName = UUID.randomUUID().toString() + fileExt;
            String filePath = uploadPath + File.separator + uniqueFileName;
            
            // 파일 저장
            filePart.write(filePath);
            
            // 데이터베이스에 저장할 상대 경로
            imagePath = UPLOAD_DIR + "/" + uniqueFileName;
            
            System.out.println("이미지 업로드 성공: " + imagePath);
            System.out.println("실제 업로드 경로: " + uploadPath);
            System.out.println("실제 업로드 경로: " + imagePath);
        }

        UserDAO userDAO = new UserDAO();
        int userId = userDAO.getUserIdByEmail(email);
        /*
        PostDAO postDAO = new PostDAO();
        boolean success = postDAO.insertPost(userId, title, storeName, location, foodType, content, x, y);
        */
        // 게시물 저장
        PostDAO postDAO = new PostDAO();
        boolean success = postDAO.insertPostWithImage(userId, title, storeName, location, foodType, content, x, y, imagePath);

        if (success) {
            response.sendRedirect("/jsp_project/board");
        } else {
            response.sendRedirect("/jsp_project/write.jsp?error=insertFailed");
        }
    }
}
