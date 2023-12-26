import java.sql.*;
import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.util.LinkedHashMap;
import java.util.Map;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class Project3 {

    private static int currentQueryIndex = 0;
    private static Map<String, String> queries = new LinkedHashMap<>();
    private static Connection conn;

    public static void main(String[] args) {
        String connectionString = "jdbc:sqlserver://localhost:13001;databaseName=QueensClassSchedule"
                + ";user=sa;password=PH@123456789;encrypt=true;trustServerCertificate=true";

        // Initialize queries
        initializeQueries();

        try {
            conn = DriverManager.getConnection(connectionString);
            displayQueryDialog();
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Error: " + e.getMessage());
        }
    }

    private static void initializeQueries() {
        queries.put("1. List of Instructors with Full Names", "SELECT InstructorId, FullName FROM Group3.Instructors");
        queries.put("2. Count of Classes by Department", "SELECT d.DepartmentId, d.Department, COUNT(c.ClassId) AS ClassCount FROM Group3.Class c JOIN Group3.Instructors i ON c.InstructorId = i.InstructorId JOIN Group3.Department d ON i.InstructorId = d.DepartmentId GROUP BY d.DepartmentId, d.Department");
        queries.put("3. List the number of classes in each building", "SELECT b.BuildingId, b.BuildingName, COUNT(c.ClassId) AS ClassCount FROM Group3.Building b JOIN Group3.Room r ON b.BuildingId = r.BuildingId JOIN Group3.Class c ON r.RoomId = c.RoomId GROUP BY b.BuildingId, b.BuildingName");
        queries.put("4. List of Classes with Mode of Instruction", "SELECT c.ClassId, c.Semester, c.Section, m.ModeOfInstruction FROM Group3.Class c JOIN Group3.ModeOfInstruction m ON c.ModeOfInstructionId = m.ModeId");
        queries.put("5. List the instructors and the classes they teach", "SELECT i.InstructorId, i.FullName, c.ClassId, c.StartTime, c.EndTime, c.Day FROM Group3.Instructors i JOIN Group3.Class c ON i.InstructorId = c.InstructorId");
        queries.put("6. Room Usage Schedule", "SELECT r.RoomId, r.RoomNo, c.ClassId, c.StartTime, c.EndTime, c.Day FROM Group3.Room r JOIN Group3.Class c ON r.RoomId = c.RoomId");
        queries.put("7. List building room with number in order of building name", "SELECT B.BuildingName, R.RoomNo FROM Group3.Building B INNER JOIN Group3.Room R ON B.BuildingId = R.BuildingId ORDER BY B.BuildingName");
        queries.put("8. Instructors sharing the same room", "SELECT R.RoomNo, COUNT(DISTINCT C.InstructorId) AS NumberOfInstructors FROM Group3.Class C INNER JOIN Group3.Room R ON C.RoomId = R.RoomId GROUP BY R.RoomNo ORDER BY NumberOfInstructors DESC");
        queries.put("9. Weekly schedule for each instructor", "SELECT i.FullName, c.Day, c.StartTime, c.EndTime, r.RoomNo, b.BuildingName FROM Group3.Class c JOIN Group3.Instructors i ON c.InstructorId = i.InstructorId JOIN Group3.Room r ON c.RoomId = r.RoomId LEFT JOIN Group3.Building b ON r.BuildingId = b.BuildingId WHERE c.StartTime IS NOT NULL AND c.EndTime IS NOT NULL AND c.Day IS NOT NULL ORDER BY i.FullName, c.Day, c.StartTime");
        queries.put("10. Average class size for each instructor", "SELECT i.FullName, AVG(c.Enrolled) AS AverageClassSize FROM Group3.Class AS c INNER JOIN Group3.Instructors AS i ON c.InstructorId = i.InstructorId GROUP BY i.FullName");
        queries.put("11. Room Utilization Report", "SELECT R.RoomNo, B.BuildingName, COUNT(C.ClassId) AS NumberOfClasses, STRING_AGG(CONCAT(C.Day, ' ', C.StartTime, ' - ', C.EndTime), ', ') AS Schedule FROM Group3.Room R JOIN Group3.Building B ON R.BuildingId = B.BuildingId JOIN Group3.Class C ON R.RoomId = C.RoomId GROUP BY R.RoomNo, B.BuildingName ORDER BY NumberOfClasses DESC");
        queries.put("12. Classes on Monday and Wednesday", "SELECT * FROM Group3.Class WHERE Day LIKE '%M%' AND Day LIKE '%W%'");
        queries.put("13. Classes with no Rooms assigned", "SELECT * FROM Group3.Class WHERE RoomId IS NULL");
    }
    

    private static void displayQueryDialog() throws SQLException {
        if (currentQueryIndex >= queries.size()) {
            return; // No more queries
        }

        String description = (String) queries.keySet().toArray()[currentQueryIndex];
        String query = queries.get(description);

        executeAndDisplayQuery(description, query);
    }

    private static void executeAndDisplayQuery(String description, String query) throws SQLException {
        try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(query)) {
            DefaultTableModel model = new DefaultTableModel();
            ResultSetMetaData metaData = rs.getMetaData();
            int columnCount = metaData.getColumnCount();

            for (int i = 1; i <= columnCount; i++) {
                model.addColumn(metaData.getColumnName(i));
            }

            while (rs.next()) {
                Object[] row = new Object[columnCount];
                for (int i = 1; i <= columnCount; i++) {
                    row[i - 1] = rs.getObject(i);
                }
                model.addRow(row);
            }

            JTable table = new JTable(model);
            JPanel panel = new JPanel();
            panel.setLayout(new BoxLayout(panel, BoxLayout.Y_AXIS));
            panel.add(new JLabel(description));
            panel.add(new JScrollPane(table));

            JButton nextButton = new JButton("Next");
            nextButton.addActionListener(new ActionListener() {
                public void actionPerformed(ActionEvent e) {
                    currentQueryIndex++;
                    if (currentQueryIndex < queries.size()) {
                        try {
                            displayQueryDialog();
                        } catch (SQLException ex) {
                            JOptionPane.showMessageDialog(null, "Error: " + ex.getMessage());
                        }
                    }
                }
            });
            panel.add(nextButton);

            JDialog dialog = new JDialog();
            dialog.setTitle("Query Results");
            dialog.setContentPane(panel);
            dialog.setDefaultCloseOperation(JDialog.DISPOSE_ON_CLOSE);
            dialog.setModal(true);
            dialog.setResizable(true);
            dialog.pack();
            dialog.setLocationRelativeTo(null);
            dialog.setVisible(true);
        }
    }
}
