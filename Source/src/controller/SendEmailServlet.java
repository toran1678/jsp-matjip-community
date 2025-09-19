package controller;

import java.io.IOException;
import java.util.Random;
import java.util.Properties;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import javax.mail.*;
import javax.mail.internet.*;
import util.ConfigUtil;

@WebServlet("/sendEmail")
public class SendEmailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public SendEmailServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");

        // 인증코드 6자리 랜덤 생성
        String code = String.format("%06d", new Random().nextInt(999999));

        // 설정 파일에서 이메일 정보 읽기
        final String fromEmail = ConfigUtil.getEmailAddress();
        final String password = ConfigUtil.getEmailPassword();

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(email));
            message.setSubject("회원가입 이메일 인증번호");
            message.setText("인증번호: " + code);

            Transport.send(message);

            System.out.println("이메일 전송 완료!");

        } catch (MessagingException e) {
            throw new RuntimeException(e);
        }

        // 클라이언트에 인증코드 보내주기
        response.setContentType("text/plain");
        response.getWriter().write(code);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}