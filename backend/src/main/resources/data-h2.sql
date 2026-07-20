INSERT INTO t_user (id, username, password, real_name, role, gender) VALUES
(5, 'admin', '123456', '系统管理员', 'ADMIN', '男');

INSERT INTO t_user (id, username, password, real_name, role, class_name, student_no) VALUES
(1, 'teacher01', '123456', '王老师', 'TEACHER', NULL, NULL);

INSERT INTO t_user (id, username, password, real_name, role, class_name, student_no) VALUES
(2, 'stu01', '123456', '张三', 'STUDENT', '软件工程2班', '2306002101');

INSERT INTO t_user (id, username, password, real_name, role, class_name, student_no) VALUES
(3, 'stu02', '123456', '李四', 'STUDENT', '软件工程2班', '2306002102');

INSERT INTO t_user (id, username, password, real_name, role, class_name, student_no) VALUES
(4, 'stu03', '123456', '王五', 'STUDENT', '软件工程1班', '2306001101');

INSERT INTO t_course (id, course_name, description, teacher_id) VALUES
(1, '数据结构与算法', '常见数据结构（数组、链表、栈、队列、树、图）与经典算法（排序、查找、动态规划等）', 1),
(2, '软件测试基础', '软件测试基本概念、测试流程、测试策略、测试文档编写等基础知识', 1),
(3, '黑盒测试技术', '等价类划分、边界值分析、因果图、决策表、正交实验法等黑盒测试方法', 1),
(4, '白盒测试技术', '语句覆盖、分支覆盖、路径覆盖、条件覆盖等白盒测试技术与代码审查', 1),
(5, '自动化测试', 'Selenium、JUnit、TestNG等自动化测试框架的使用与脚本开发', 1),
(6, '软件缺陷管理', '缺陷生命周期、缺陷报告编写、缺陷跟踪工具（Jira/Bugzilla）使用', 1);

INSERT INTO t_course_student (course_id, student_id) VALUES
(1,2),(1,3),(2,2),(2,3),(2,4),(3,2),(3,4),(4,3),(4,4),(5,2),(5,3),(6,4);

INSERT INTO t_experiment_task (id, course_id, title, description, requirement, teacher_id, deadline, status) VALUES
(1, 1, '实验一：黑盒测试用例设计', '掌握等价类划分、边界值分析等黑盒测试方法，设计测试用例。', '1. 使用等价类划分法设计测试用例
2. 使用边界值分析法设计测试用例
3. 编写测试用例文档', 1, DATEADD('DAY', 14, NOW()), 1),
(2, 1, '实验二：白盒测试与代码覆盖', '学习语句覆盖、分支覆盖、路径覆盖等白盒测试技术。', '1. 选择被测代码模块
2. 绘制程序流程图
3. 设计白盒测试用例
4. 进行代码覆盖率分析', 1, DATEADD('DAY', 21, NOW()), 1),
(3, 1, '实验三：自动化测试脚本开发', '使用Selenium等工具编写自动化测试脚本。', '1. 搭建自动化测试环境
2. 编写登录功能自动化测试脚本
3. 编写数据驱动测试脚本
4. 生成测试报告', 1, DATEADD('DAY', 30, NOW()), 1);

INSERT INTO t_submission (id, task_id, student_id, code_text, status, score, comment, submit_time, review_time) VALUES
(1, 1, 2, '// 等价类划分测试用例（Java）
public class EquivalencePartitionTest {
    // 有效等价类：1-100之间的整数
    @Test
    public void testValidInput() {
        Calculator calc = new Calculator();
        assertEquals(50, calc.compute(50));
    }
    // 无效等价类：小于1
    @Test
    public void testBelowRange() {
        Calculator calc = new Calculator();
        assertThrows(IllegalArgumentException.class, () -> calc.compute(-1));
    }
    // 无效等价类：大于100
    @Test
    public void testAboveRange() {
        Calculator calc = new Calculator();
        assertThrows(IllegalArgumentException.class, () -> calc.compute(101));
    }
}', 2, 88, '等价类划分正确，边界值测试需补充负数边界。代码格式规范，继续加油！', DATEADD('DAY', -5, NOW()), DATEADD('DAY', -3, NOW()));

INSERT INTO t_submission (id, task_id, student_id, file_path, file_url, file_name, status, score, comment, submit_time, review_time) VALUES
(2, 1, 3, '/uploads/submissions/1/3/sample_test_report.txt', '/uploads/submissions/1/3/sample_test_report.txt', '测试用例设计报告.txt', 2, 92, '测试用例设计非常全面，等价类和边界值覆盖完整，文档格式规范。', DATEADD('DAY', -4, NOW()), DATEADD('DAY', -2, NOW()));

INSERT INTO t_submission (id, task_id, student_id, code_text, file_path, file_url, file_name, status, submit_time) VALUES
(3, 1, 4, '// 边界值分析法测试
@Test
public void testBoundaryValues() {
    // 上点：100
    assertEquals(100, calc.compute(100));
    // 离点：0, 101
    assertThrows(Exception.class, () -> calc.compute(0));
    assertThrows(Exception.class, () -> calc.compute(101));
    // 内点：50
    assertEquals(50, calc.compute(50));
}', '/uploads/submissions/1/4/boundary_test_cases.xlsx', '/uploads/submissions/1/4/boundary_test_cases.xlsx', '边界值测试用例.xlsx', 1, DATEADD('DAY', -2, NOW()));
