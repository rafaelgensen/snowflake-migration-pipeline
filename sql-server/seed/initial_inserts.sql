-- Funcionários
EXEC HR.AddEmployee 'Maria', 'Silva', '2020-01-10', 'Finance';
EXEC HR.AddEmployee 'João', 'Souza', '2021-03-15', 'IT';
EXEC HR.AddEmployee 'Ana', 'Costa', '2019-08-01', 'HR';

-- Salários iniciais
EXEC HR.UpdateSalary 1, 5000.00, '2020-01-10';
EXEC HR.UpdateSalary 2, 7000.00, '2021-03-15';
EXEC HR.UpdateSalary 3, 4500.00, '2019-08-01';

-- Alteração salarial
EXEC HR.UpdateSalary 2, 7500.00, '2022-01-01';
