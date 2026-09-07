package com.mycompany.sinema.DAO;

import com.mycompany.sinema.model.Admin;
import com.mycompany.sinema.util.DBConnection;

import java.sql.*;

public class AdminDAO {

    public Admin authenticate(String email, String password) throws Exception {
        String sql = "SELECT admin_id, user_id, position, adminEmail, role, password " +
                "FROM admins WHERE adminEmail=? AND password=?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Admin a = new Admin();
                    a.setAdminId(rs.getInt("admin_id"));
                    a.setUserId(rs.getInt("user_id"));
                    a.setPosition(rs.getString("position"));
                    a.setAdminEmail(rs.getString("adminEmail"));
                    a.setRole(rs.getString("role"));
                    a.setAdminPassword(rs.getString("password"));
                    return a;
                }
            }
        }
        return null;
    }

    // Load full profile
    public Admin getProfileByAdminId(int adminId) throws Exception {
        String sql = "SELECT a.admin_id, a.user_id, a.position, a.adminEmail, a.role, a.password, " +
                "       u.username, u.email AS userEmail, u.admin_phone " +
                "FROM admins a " +
                "JOIN users u ON a.user_id = u.user_id " +
                "WHERE a.admin_id=?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, adminId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Admin a = new Admin();
                    a.setAdminId(rs.getInt("admin_id"));
                    a.setUserId(rs.getInt("user_id"));
                    a.setPosition(rs.getString("position"));
                    a.setAdminEmail(rs.getString("adminEmail"));
                    a.setRole(rs.getString("role"));
                    a.setAdminPassword(rs.getString("password"));

                    a.setUsername(rs.getString("username"));
                    a.setUserEmail(rs.getString("userEmail"));
                    a.setPhoneNo(rs.getString("admin_phone"));
                    return a;
                }
            }
        }
        return null;
    }

    // Update profile
    public boolean updateProfile(Admin a, String newPasswordOrNull) throws Exception {
        String updateAdminsWithPass = "UPDATE admins SET adminEmail=?, position=?, password=? WHERE admin_id=?";
        String updateAdminsNoPass = "UPDATE admins SET adminEmail=?, position=? WHERE admin_id=?";

        String updateUsers = "UPDATE users SET username=?, email=?, admin_phone=? WHERE user_id=?";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);

            try {
                try (PreparedStatement psU = conn.prepareStatement(updateUsers)) {
                    psU.setString(1, a.getUsername());
                    psU.setString(2, a.getUserEmail());
                    psU.setString(3, a.getAdminPhone());
                    psU.setInt(4, a.getUserId());
                    psU.executeUpdate();
                }

                if (newPasswordOrNull != null && !newPasswordOrNull.trim().isEmpty()) {
                    try (PreparedStatement psA = conn.prepareStatement(updateAdminsWithPass)) {
                        psA.setString(1, a.getAdminEmail());
                        psA.setString(2, a.getPosition());
                        psA.setString(3, newPasswordOrNull); // (ideally hash)
                        psA.setInt(4, a.getAdminId());
                        psA.executeUpdate();
                    }
                } else {
                    try (PreparedStatement psA = conn.prepareStatement(updateAdminsNoPass)) {
                        psA.setString(1, a.getAdminEmail());
                        psA.setString(2, a.getPosition());
                        psA.setInt(3, a.getAdminId());
                        psA.executeUpdate();
                    }
                }

                conn.commit();
                return true;

            } catch (Exception ex) {
                conn.rollback();
                throw ex;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }
}
