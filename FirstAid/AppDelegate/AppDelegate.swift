//
//  AppDelegate.swift
//  FirstAid
//
//  Created by Анна Шанидзе on 22.10.2021.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        preloadDBData()
        fixNavigationBar()
        
        application.applicationIconBadgeNumber = 0
        NotificationManager.shared.removeNotifications()
        NotificationManager.shared.requestAuthorization { granted in
            if granted {
                NotificationManager.shared.scheduleNotification()
            }
        }
        return true
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }
    
    
    // MARK: - UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    
    // MARK: - Fix Nav Bar tint issue in iOS 15.0 or later
    
    func fixNavigationBar() {
        if #available(iOS 15.0, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithDefaultBackground()
            navigationBarAppearance.backgroundColor = .systemRed
            navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navigationBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
            
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground()
            tabBarAppearance.backgroundColor = .systemBackground
            UITabBar.appearance().standardAppearance = tabBarAppearance
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
    
    // MARK: - Core Data
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "QuestDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func preloadDBData() {
        let sqlitePath = Bundle.main.path(forResource: "QuestDataModel", ofType: "sqlite")
        let sqlitePath_shm = Bundle.main.path(forResource: "QuestDataModel", ofType: "sqlite-shm")
        let sqlitePath_wal = Bundle.main.path(forResource: "QuestDataModel", ofType: "sqlite-wal")

        let URL1 = URL(fileURLWithPath: sqlitePath!)
        let URL2 = URL(fileURLWithPath: sqlitePath_shm!)
        let URL3 = URL(fileURLWithPath: sqlitePath_wal!)
        let URL4 = URL(fileURLWithPath: NSPersistentContainer.defaultDirectoryURL().relativePath + "/QuestDataModel.sqlite")
        let URL5 = URL(fileURLWithPath: NSPersistentContainer.defaultDirectoryURL().relativePath + "/QuestDataModel.sqlite-shm")
        let URL6 = URL(fileURLWithPath: NSPersistentContainer.defaultDirectoryURL().relativePath + "/QuestDataModel.sqlite-wal")

        if !FileManager.default.fileExists(atPath: NSPersistentContainer.defaultDirectoryURL().relativePath + "/QuestDataModel.sqlite") {
            do {
                try FileManager.default.copyItem(at: URL1, to: URL4)
                try FileManager.default.copyItem(at: URL2, to: URL5)
                try FileManager.default.copyItem(at: URL3, to: URL6)

                print("=======================")
                print("FILES COPIED")
                print("=======================")

            } catch {
                print("=======================")
                print("ERROR IN COPY OPERATION")
                print("=======================")
            }
        } else {
            print("=======================")
            print("FILES EXIST")
            print("=======================")
        }
    }
    
}

